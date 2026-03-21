# Notification Delivery Implementation Guide

## Current State
Currently, notifications are only **stored** in MongoDB. Users must poll the API every 30 seconds to check for new notifications. This guide outlines different approaches to actually **deliver** notifications to users in real-time.

---

## Option 1: WebSockets (Recommended for Real-Time)

### Best For: Real-time in-app notifications when users are active

### Services/Technologies:
- **FastAPI WebSockets** (built-in, no external service needed)
- **Alternative**: Socket.io with python-socketio

### Implementation:

#### Backend Changes (`backend/server.py`):

```python
from fastapi import WebSocket, WebSocketDisconnect
from typing import Dict, List
import json

# Store active WebSocket connections
class ConnectionManager:
    def __init__(self):
        # Maps user_id -> List of WebSocket connections
        self.active_connections: Dict[str, List[WebSocket]] = {}

    async def connect(self, websocket: WebSocket, user_id: str):
        await websocket.accept()
        if user_id not in self.active_connections:
            self.active_connections[user_id] = []
        self.active_connections[user_id].append(websocket)

    def disconnect(self, websocket: WebSocket, user_id: str):
        if user_id in self.active_connections:
            self.active_connections[user_id].remove(websocket)
            if not self.active_connections[user_id]:
                del self.active_connections[user_id]

    async def send_personal_message(self, message: dict, user_id: str):
        if user_id in self.active_connections:
            for connection in self.active_connections[user_id]:
                try:
                    await connection.send_json(message)
                except Exception as e:
                    logger.error(f"Error sending message to {user_id}: {e}")
                    self.disconnect(connection, user_id)

manager = ConnectionManager()

# WebSocket endpoint
@api_router.websocket("/ws/{token}")
async def websocket_endpoint(websocket: WebSocket, token: str):
    # Verify token and get user
    try:
        payload = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        user_id = payload.get("user_id")
        if not user_id:
            await websocket.close(code=4001, reason="Invalid token")
            return
        
        user = await db.users.find_one({"id": user_id})
        if not user:
            await websocket.close(code=4001, reason="User not found")
            return
    except jwt.ExpiredSignatureError:
        await websocket.close(code=4001, reason="Token expired")
        return
    except Exception as e:
        await websocket.close(code=4001, reason="Invalid token")
        return
    
    await manager.connect(websocket, user_id)
    
    try:
        while True:
            # Keep connection alive with ping
            data = await websocket.receive_text()
            # Handle ping/pong or other messages
            await websocket.send_json({"type": "pong"})
    except WebSocketDisconnect:
        manager.disconnect(websocket, user_id)

# Modify create_recipe to send WebSocket notifications
@api_router.post("/recipes", response_model=RecipeResponse)
async def create_recipe(recipe_data: RecipeCreate, user: dict = Depends(get_current_user)):
    # ... existing recipe creation code ...
    
    # Create notifications for all other family members
    all_users = await db.users.find({"id": {"$ne": user["id"]}}, {"_id": 0, "id": 1}).to_list(100)
    notifications = []
    for other_user in all_users:
        notification_doc = {
            "id": str(uuid.uuid4()),
            "user_id": other_user["id"],
            "type": "new_recipe",
            "message": f"{display_name} shared a new recipe: {recipe_data.title}",
            "recipe_id": recipe_id,
            "from_user_name": display_name,
            "is_read": False,
            "created_at": datetime.now(timezone.utc).isoformat()
        }
        notifications.append(notification_doc)
        
        # Send real-time notification via WebSocket
        await manager.send_personal_message({
            "type": "notification",
            "data": notification_doc
        }, other_user["id"])
    
    if notifications:
        await db.notifications.insert_many(notifications)
    
    return RecipeResponse(**{k: v for k, v in recipe_doc.items() if k != "_id"})
```

#### Frontend Changes (`frontend/src/App.js`):

```javascript
useEffect(() => {
  if (user && token) {
    // Connect to WebSocket
    const ws = new WebSocket(`ws://localhost:8000/api/ws/${token}`);
    
    ws.onopen = () => {
      console.log("WebSocket connected");
    };
    
    ws.onmessage = (event) => {
      const message = JSON.parse(event.data);
      if (message.type === "notification") {
        // Add notification to state
        setNotifications(prev => [message.data, ...prev]);
        setUnreadCount(prev => prev + 1);
        // Show toast notification
        toast.info(message.data.message);
      }
    };
    
    ws.onerror = (error) => {
      console.error("WebSocket error:", error);
    };
    
    ws.onclose = () => {
      console.log("WebSocket disconnected, reconnecting...");
      // Implement reconnection logic
    };
    
    return () => {
      ws.close();
    };
  }
}, [user, token]);
```

### Pros:
- ✅ Real-time delivery
- ✅ No external service needed
- ✅ Low latency
- ✅ Works for web and mobile apps

### Cons:
- ❌ Requires persistent connection
- ❌ More complex to handle reconnections
- ❌ Not suitable for offline users

---

## Option 2: Server-Sent Events (SSE)

### Best For: Simpler real-time solution, one-way communication

### Services/Technologies:
- **FastAPI StreamingResponse** (built-in)

### Implementation:

```python
from fastapi.responses import StreamingResponse
import asyncio

# Store SSE connections
sse_connections: Dict[str, List] = {}

@api_router.get("/notifications/stream")
async def stream_notifications(user: dict = Depends(get_current_user)):
    async def event_generator():
        queue = asyncio.Queue()
        user_id = user["id"]
        
        # Add this connection to the list
        if user_id not in sse_connections:
            sse_connections[user_id] = []
        sse_connections[user_id].append(queue)
        
        try:
            # Send initial connection message
            yield f"data: {json.dumps({'type': 'connected'})}\n\n"
            
            while True:
                # Wait for new notification
                notification = await asyncio.wait_for(queue.get(), timeout=30.0)
                yield f"data: {json.dumps(notification)}\n\n"
        except asyncio.TimeoutError:
            yield f"data: {json.dumps({'type': 'ping'})}\n\n"
        finally:
            # Remove connection
            if user_id in sse_connections:
                sse_connections[user_id].remove(queue)
                if not sse_connections[user_id]:
                    del sse_connections[user_id]
    
    return StreamingResponse(
        event_generator(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
        }
    )

# In create_recipe, send to SSE connections:
async def send_sse_notification(user_id: str, notification: dict):
    if user_id in sse_connections:
        for queue in sse_connections[user_id]:
            await queue.put(notification)
```

### Frontend:

```javascript
useEffect(() => {
  if (user && token) {
    const eventSource = new EventSource(
      `${API}/notifications/stream`,
      {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    
    eventSource.onmessage = (event) => {
      const data = JSON.parse(event.data);
      if (data.type === "notification") {
        setNotifications(prev => [data, ...prev]);
        setUnreadCount(prev => prev + 1);
      }
    };
    
    return () => eventSource.close();
  }
}, [user, token]);
```

### Pros:
- ✅ Simpler than WebSockets
- ✅ Automatic reconnection
- ✅ One-way is sufficient for notifications

### Cons:
- ❌ One-way only (server to client)
- ❌ Not supported by all browsers (Edge issues)

---

## Option 3: Push Notifications (For Mobile/Web)

### Best For: Notifications when app is closed or user is offline

### Services/Technologies:

#### A. Firebase Cloud Messaging (FCM) - Recommended
- **Package**: `firebase-admin` (backend), `firebase` (frontend)
- **Free tier**: 10K messages/day
- **Setup**: Requires Firebase project

```python
# Install: pip install firebase-admin

import firebase_admin
from firebase_admin import credentials, messaging

# Initialize (once)
cred = credentials.Certificate("path/to/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

# In create_recipe:
async def send_push_notification(user_id: str, notification: dict):
    # Get user's FCM token from database
    user = await db.users.find_one({"id": user_id})
    fcm_token = user.get("fcm_token")
    
    if fcm_token:
        message = messaging.Message(
            notification=messaging.Notification(
                title="New Recipe Shared",
                body=notification["message"],
            ),
            data={
                "type": notification["type"],
                "recipe_id": notification.get("recipe_id", ""),
            },
            token=fcm_token,
        )
        try:
            response = messaging.send(message)
            logger.info(f"Push notification sent: {response}")
        except Exception as e:
            logger.error(f"Error sending push: {e}")

# Add endpoint to register FCM token
@api_router.post("/users/fcm-token")
async def register_fcm_token(fcm_token: str, user: dict = Depends(get_current_user)):
    await db.users.update_one(
        {"id": user["id"]},
        {"$set": {"fcm_token": fcm_token}}
    )
    return {"message": "FCM token registered"}
```

#### B. OneSignal - Alternative
- **Package**: `onesignal-sdk`
- **Free tier**: 10K subscribers
- **Setup**: Requires OneSignal account

```python
# Install: pip install onesignal-sdk

from onesignal import OneSignal

onesignal_client = OneSignal(
    app_id=os.environ["ONESIGNAL_APP_ID"],
    rest_api_key=os.environ["ONESIGNAL_REST_API_KEY"]
)

async def send_onesignal_notification(user_id: str, notification: dict):
    user = await db.users.find_one({"id": user_id})
    player_id = user.get("onesignal_player_id")
    
    if player_id:
        response = onesignal_client.send_notification({
            "contents": {"en": notification["message"]},
            "include_player_ids": [player_id],
            "data": notification
        })
```

### Pros:
- ✅ Works when app is closed
- ✅ Cross-platform (iOS, Android, Web)
- ✅ Reliable delivery

### Cons:
- ❌ Requires external service setup
- ❌ User must grant permission
- ❌ Need to manage device tokens

---

## Option 4: Email Notifications

### Best For: Important notifications, backup delivery method

### Services/Technologies:

#### A. SendGrid (Recommended)
- **Package**: `sendgrid`
- **Free tier**: 100 emails/day

```python
# Install: pip install sendgrid

from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail

sg = SendGridAPIClient(os.environ["SENDGRID_API_KEY"])

async def send_email_notification(user_id: str, notification: dict):
    user = await db.users.find_one({"id": user_id})
    email = user.get("email")
    
    if email:
        message = Mail(
            from_email="noreply@yourfamilyrecipes.com",
            to_emails=email,
            subject=f"New Recipe: {notification.get('recipe_id', 'Shared')}",
            html_content=f"""
            <html>
            <body>
                <h2>{notification['message']}</h2>
                <p>Click <a href="https://yourapp.com/recipe/{notification.get('recipe_id')}">here</a> to view</p>
            </body>
            </html>
            """
        )
        try:
            response = sg.send(message)
            logger.info(f"Email sent: {response.status_code}")
        except Exception as e:
            logger.error(f"Error sending email: {e}")
```

#### B. AWS SES (Simple Email Service)
- **Package**: `boto3` (already in requirements.txt!)
- **Free tier**: 62,000 emails/month (first 12 months)

```python
import boto3

ses_client = boto3.client(
    'ses',
    aws_access_key_id=os.environ['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key=os.environ['AWS_SECRET_ACCESS_KEY'],
    region_name=os.environ.get('AWS_REGION', 'us-east-1')
)

async def send_ses_email(user_id: str, notification: dict):
    user = await db.users.find_one({"id": user_id})
    email = user.get("email")
    
    if email:
        try:
            response = ses_client.send_email(
                Source='noreply@yourfamilyrecipes.com',
                Destination={'ToAddresses': [email]},
                Message={
                    'Subject': {'Data': 'New Recipe Shared'},
                    'Body': {
                        'Html': {
                            'Data': f"<h2>{notification['message']}</h2>"
                        }
                    }
                }
            )
            logger.info(f"Email sent: {response['MessageId']}")
        except Exception as e:
            logger.error(f"Error sending email: {e}")
```

### Pros:
- ✅ Works offline
- ✅ User doesn't need app open
- ✅ Reliable for important notifications

### Cons:
- ❌ Can be marked as spam
- ❌ Requires email service setup
- ❌ Less immediate than push

---

## Option 5: Hybrid Approach (Recommended)

### Combine multiple methods for best coverage:

```python
async def deliver_notification(user_id: str, notification: dict):
    """Multi-channel notification delivery"""
    
    # 1. Store in database (always)
    await db.notifications.insert_one(notification)
    
    # 2. Send via WebSocket if user is online
    await manager.send_personal_message({
        "type": "notification",
        "data": notification
    }, user_id)
    
    # 3. Send push notification (works offline)
    await send_push_notification(user_id, notification)
    
    # 4. Send email for important notifications (optional)
    if notification.get("type") == "important":
        await send_email_notification(user_id, notification)
```

---

## Recommended Implementation Plan

### Phase 1: WebSockets (Quick Win)
1. Add WebSocket support to backend
2. Update frontend to connect on login
3. Send notifications in real-time when users are online

### Phase 2: Push Notifications (Mobile Support)
1. Integrate Firebase Cloud Messaging
2. Add FCM token registration endpoint
3. Send push notifications for offline users

### Phase 3: Email Backup (Important Notifications)
1. Add SendGrid or AWS SES
2. Configure email templates
3. Send emails for critical notifications

---

## Dependencies to Add

```txt
# For WebSockets (already supported in FastAPI, just need python-multipart)
# Already installed: python-multipart>=0.0.9

# For Push Notifications (FCM)
firebase-admin>=6.0.0

# For Email (Choose one)
sendgrid>=6.9.0
# OR use boto3 (already in requirements.txt) for AWS SES

# For OneSignal (alternative)
onesignal-sdk>=1.0.5
```

---

## Environment Variables Needed

```bash
# For FCM
FIREBASE_CREDENTIALS_PATH=/path/to/serviceAccountKey.json

# For SendGrid
SENDGRID_API_KEY=your_api_key

# For AWS SES (if using boto3)
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_REGION=us-east-1

# For OneSignal (alternative)
ONESIGNAL_APP_ID=your_app_id
ONESIGNAL_REST_API_KEY=your_rest_api_key
```

---

## Summary Table

| Method | Real-Time | Offline | Complexity | External Service | Cost |
|--------|-----------|---------|------------|------------------|------|
| WebSockets | ✅ | ❌ | Medium | None | Free |
| SSE | ✅ | ❌ | Low | None | Free |
| FCM Push | ✅ | ✅ | Medium | Firebase | Free tier |
| OneSignal | ✅ | ✅ | Low | OneSignal | Free tier |
| SendGrid Email | ❌ | ✅ | Low | SendGrid | Free tier |
| AWS SES | ❌ | ✅ | Low | AWS | Free tier |

---

## Next Steps

1. **Choose your approach** based on your needs
2. **Start with WebSockets** for immediate real-time capability
3. **Add push notifications** for mobile app (Flutter) later
4. **Consider email** for important family updates

Would you like me to implement any of these solutions?
