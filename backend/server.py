from fastapi import FastAPI, APIRouter, HTTPException, Depends, status, Request
from fastapi.exceptions import RequestValidationError
from fastapi.exception_handlers import request_validation_exception_handler
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from dotenv import load_dotenv
from starlette.middleware.cors import CORSMiddleware
from starlette.responses import JSONResponse
from starlette.middleware.base import BaseHTTPMiddleware
from motor.motor_asyncio import AsyncIOMotorClient
from pymongo.errors import PyMongoError
import os
import logging
from pathlib import Path
from pydantic import BaseModel, Field, ConfigDict, EmailStr
from typing import List, Optional
from contextlib import asynccontextmanager
import uuid
from datetime import datetime, timezone, timedelta
import jwt
import bcrypt
import json
import httpx

ROOT_DIR = Path(__file__).parent
load_dotenv(ROOT_DIR / '.env')

# MongoDB connection
mongo_url = os.environ['MONGO_URL']
client = AsyncIOMotorClient(mongo_url)
db = client[os.environ['DB_NAME']]

# JWT Configuration
JWT_SECRET = os.environ['JWT_SECRET']
JWT_ALGORITHM = "HS256"
JWT_EXPIRATION_HOURS = 24 * 7  # 7 days

@asynccontextmanager
async def lifespan(_app: FastAPI):
    try:
        await client.admin.command("ping")
        logger.info("Database connection OK")
    except PyMongoError as e:
        logger.error("Database connection failed at startup: type=%s message=%s", type(e).__name__, e)
    yield
    client.close()

# Create the main app
app = FastAPI(lifespan=lifespan)
api_router = APIRouter(prefix="/api")
security = HTTPBearer()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    force=True,
)
logger = logging.getLogger(__name__)

# Maximum request body size: 50MB (for large base64 image payloads)
MAX_REQUEST_BODY_SIZE = 50 * 1024 * 1024  # 50MB

# Middleware to check request body size before processing
class LargeBodyMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # Check Content-Length header for size validation
        content_length = request.headers.get("content-length")
        if content_length:
            try:
                size = int(content_length)
                if size > MAX_REQUEST_BODY_SIZE:
                    logger.warning(
                        "Request body too large path=%s size=%d max=%d",
                        request.url.path,
                        size,
                        MAX_REQUEST_BODY_SIZE
                    )
                    return JSONResponse(
                        status_code=413,
                        content={
                            "detail": (
                                f"Request body too large ({size / (1024*1024):.1f}MB). "
                                f"Maximum size is {MAX_REQUEST_BODY_SIZE // (1024*1024)}MB. "
                                "Please reduce the number of photos or use smaller images."
                            )
                        }
                    )
            except ValueError:
                pass
        
        # Let the request proceed - FastAPI will handle body reading
        return await call_next(request)

# Exception handlers: log all errors to console
@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    logger.error("HTTPException path=%s status=%s detail=%s", request.url.path, exc.status_code, exc.detail)
    return JSONResponse(status_code=exc.status_code, content={"detail": exc.detail})


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    errors = exc.errors() if hasattr(exc, "errors") else []
    for err in errors:
        if err.get("type") == "json_invalid":
            ctx = err.get("ctx", {})
            error_msg = ctx.get("error", "Unknown JSON error")
            logger.warning(
                "JSON decode error path=%s type=%s ctx=%s loc=%s",
                request.url.path,
                err.get("type"),
                ctx,
                err.get("loc", []),
            )
            
            # Check if it's an unterminated string (likely from truncated body)
            if "Unterminated string" in str(error_msg) or "unterminated" in str(error_msg).lower():
                return JSONResponse(
                    status_code=422,
                    content={
                        "detail": (
                            "Request body appears to be truncated or too large. "
                            "Please reduce the number of photos or use smaller images. "
                            "Maximum request size is 50MB."
                        )
                    },
                )
            
            # Check Content-Length to see if body might be too large
            content_length = request.headers.get("content-length")
            if content_length:
                try:
                    size_mb = int(content_length) / (1024 * 1024)
                    if size_mb > 40:  # Close to our 50MB limit
                        return JSONResponse(
                            status_code=422,
                            content={
                                "detail": (
                                    f"Request body is very large ({size_mb:.1f}MB). "
                                    "Please reduce the number of photos or compress images before uploading."
                                )
                            },
                        )
                except ValueError:
                    pass
            
            return JSONResponse(
                status_code=422,
                content={
                    "detail": (
                        "Invalid JSON in request body. Please check that all text fields are properly formatted "
                        "and try reducing the number or size of photos."
                    )
                },
            )
    return await request_validation_exception_handler(request, exc)


@app.exception_handler(Exception)
async def general_exception_handler(request: Request, exc: Exception):
    if isinstance(exc, RequestValidationError):
        return await request_validation_exception_handler(request, exc)
    if isinstance(exc, PyMongoError):
        logger.exception(
            "Database error path=%s type=%s message=%s",
            request.url.path, type(exc).__name__, str(exc)
        )
        return JSONResponse(
            status_code=503,
            content={"detail": "Database unavailable. Please try again later."}
        )
    logger.exception("Unhandled exception path=%s", request.url.path)
    return JSONResponse(status_code=500, content={"detail": "Internal server error"})

# CORS Configuration - must be added before routers
_cors_origins_raw = os.environ.get('CORS_ORIGINS', 'http://localhost:3000,http://localhost:8000')
_cors_origins = [o.strip() for o in _cors_origins_raw.split(',') if o.strip()]
logger.info(f"CORS origins configured: {_cors_origins}")

# Add middleware for large body handling (must be before CORS)
app.add_middleware(LargeBodyMiddleware)

app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_origins=_cors_origins,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"],
)

# ===================== CREDIT SYSTEM =====================

# Monthly credit allocation per subscription tier
TIER_CREDITS = {
    None: 3,          # Free tier — enough to try AI features
    "heritage": 15,   # Heritage Keeper
    "legacy": 50,     # Legacy Collection
}

# Credit costs per AI feature (used when features are built)
CREDIT_COSTS = {
    "recipe_scan": 1,       # AI recipe scanner (OCR + LLM)
    "voice_to_recipe": 2,   # Voice-to-recipe (STT + LLM)
    "ai_share_asset": 1,    # AI-generated share image
}


def get_credits_for_tier(tier: Optional[str]) -> int:
    """Return monthly credit allocation for a subscription tier."""
    return TIER_CREDITS.get(tier, TIER_CREDITS[None])


def next_refresh_date() -> str:
    """Return an ISO timestamp 30 days from now (next credit refresh)."""
    return (datetime.now(timezone.utc) + timedelta(days=30)).isoformat()


async def refresh_credits_if_needed(user: dict) -> dict:
    """Check if credits need refreshing; if so, reset balance and return updated user."""
    refresh_at = user.get("credits_refresh_at")
    if refresh_at:
        try:
            refresh_dt = datetime.fromisoformat(refresh_at)
            if refresh_dt.tzinfo is None:
                refresh_dt = refresh_dt.replace(tzinfo=timezone.utc)
            if datetime.now(timezone.utc) < refresh_dt:
                return user  # Not yet time to refresh
        except (ValueError, TypeError):
            pass  # Invalid date — refresh now

    # Time to refresh credits
    tier = user.get("subscription_tier")
    new_balance = get_credits_for_tier(tier)
    new_refresh = next_refresh_date()

    await db.users.update_one(
        {"id": user["id"]},
        {"$set": {"credits_balance": new_balance, "credits_refresh_at": new_refresh}}
    )
    user["credits_balance"] = new_balance
    user["credits_refresh_at"] = new_refresh
    return user


async def consume_credit(user: dict, feature: str) -> dict:
    """
    Deduct credits for using an AI feature.
    Raises HTTPException if insufficient credits.
    Returns updated user dict.
    """
    cost = CREDIT_COSTS.get(feature, 1)
    # Auto-refresh if needed before checking balance
    user = await refresh_credits_if_needed(user)
    balance = user.get("credits_balance", 0)

    if balance < cost:
        tier = user.get("subscription_tier")
        raise HTTPException(
            status_code=403,
            detail={
                "error": "insufficient_credits",
                "credits_balance": balance,
                "credits_needed": cost,
                "message": (
                    f"This feature costs {cost} credit{'s' if cost > 1 else ''}. "
                    f"You have {balance} remaining. "
                    + ("Upgrade your plan for more credits each month." if not tier else "Credits refresh on your billing cycle.")
                ),
            }
        )

    new_balance = balance - cost
    await db.users.update_one(
        {"id": user["id"]},
        {"$set": {"credits_balance": new_balance}}
    )
    user["credits_balance"] = new_balance
    logger.info("Credit consumed: user=%s feature=%s cost=%d remaining=%d", user["id"], feature, cost, new_balance)
    return user


# ===================== MODELS =====================

class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str
    nickname: Optional[str] = None

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class GoogleAuthRequest(BaseModel):
    credential: str  # Google ID token from GSI

class UserUpdate(BaseModel):
    nickname: Optional[str] = None
    avatar: Optional[str] = None  # Base64 encoded image

class UserResponse(BaseModel):
    model_config = ConfigDict(extra="ignore")
    id: str
    name: str
    nickname: Optional[str] = None
    email: str
    avatar: Optional[str] = None
    family_id: Optional[str] = None
    role: Optional[str] = None
    subscription_tier: Optional[str] = None  # "heritage" | "legacy" | None
    credits_balance: int = 0
    credits_refresh_at: Optional[str] = None  # ISO datetime of next refresh
    created_at: str

class TokenResponse(BaseModel):
    token: str
    user: UserResponse

# Notification Models
class NotificationResponse(BaseModel):
    model_config = ConfigDict(extra="ignore")
    id: str
    user_id: str
    type: str  # "new_recipe", "comment", etc.
    message: str
    recipe_id: Optional[str] = None
    from_user_name: str
    is_read: bool
    created_at: str

# Notification V1 Models (New family-scoped notification system)
class NotificationV1Response(BaseModel):
    model_config = ConfigDict(extra="ignore")
    id: str
    user_id: str
    family_id: str
    type: str  # "recipe_added", "comment_added", "photo_added"
    payload: dict  # Light metadata like recipe_id, author_name
    is_read: bool
    created_at: str

class RecipeCreate(BaseModel):
    title: str
    ingredients: List[str]
    instructions: str
    story: Optional[str] = None  # Optional story behind the recipe
    photos: List[str] = []  # Base64 encoded images
    cooking_time: int  # minutes
    servings: int
    category: str
    difficulty: str  # easy, medium, hard

class RecipeUpdate(BaseModel):
    title: Optional[str] = None
    ingredients: Optional[List[str]] = None
    instructions: Optional[str] = None
    story: Optional[str] = None
    photos: Optional[List[str]] = None
    cooking_time: Optional[int] = None
    servings: Optional[int] = None
    category: Optional[str] = None
    difficulty: Optional[str] = None

class RecipeResponse(BaseModel):
    model_config = ConfigDict(extra="ignore")
    id: str
    family_id: Optional[str] = None  # NEW: Optional for backward compatibility
    title: str
    ingredients: List[str]
    instructions: str
    story: Optional[str] = None
    photos: List[str]
    cooking_time: int
    servings: int
    category: str
    difficulty: str
    author_id: str
    author_name: str
    created_at: str

# Comment Models
class CommentCreate(BaseModel):
    text: str

class CommentResponse(BaseModel):
    model_config = ConfigDict(extra="ignore")
    id: str
    recipe_id: str
    user_id: str
    user_name: str
    text: str
    created_at: str

# Family Models
class FamilyCreate(BaseModel):
    name: str
    description: Optional[str] = None

class FamilyUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    cover_image: Optional[str] = None

class FamilyResponse(BaseModel):
    model_config = ConfigDict(extra="ignore")
    id: str
    name: str
    owner_id: str
    invite_code: str
    metadata: Optional[dict] = None
    created_at: str

class FamilyJoinRequest(BaseModel):
    invite_code: str

class FamilyTransferKeeperRequest(BaseModel):
    new_keeper_id: str

class DeleteAccountRequest(BaseModel):
    email: EmailStr

class FamilyMemberResponse(BaseModel):
    model_config = ConfigDict(extra="ignore")
    id: str
    name: str
    nickname: Optional[str] = None
    email: str
    avatar: Optional[str] = None
    role: str
    joined_at: Optional[str] = None  # Will use created_at from user as proxy

# ===================== AUTH HELPERS =====================

def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

def verify_password(password: str, hashed: str) -> bool:
    return bcrypt.checkpw(password.encode('utf-8'), hashed.encode('utf-8'))

def create_token(user_id: str) -> str:
    payload = {
        "user_id": user_id,
        "exp": datetime.now(timezone.utc) + timedelta(hours=JWT_EXPIRATION_HOURS)
    }
    return jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)

async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    try:
        token = credentials.credentials
        payload = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        user_id = payload.get("user_id")
        if not user_id:
            logger.warning("Auth failed: token missing user_id")
            raise HTTPException(status_code=401, detail="Invalid token")
        
        user = await db.users.find_one({"id": user_id}, {"_id": 0})
        if not user:
            logger.warning("Auth failed: user_id=%s not found", user_id)
            raise HTTPException(status_code=401, detail="User not found")
        return user
    except jwt.ExpiredSignatureError:
        logger.warning("Auth failed: token expired")
        raise HTTPException(status_code=401, detail="Token expired")
    except jwt.InvalidTokenError as e:
        logger.warning("Auth failed: invalid token - %s", e)
        raise HTTPException(status_code=401, detail="Invalid token")

# ===================== NOTIFICATION V1 HELPERS =====================

async def create_notification_v1(
    family_id: str,
    notification_type: str,
    payload: dict,
    exclude_user_id: Optional[str] = None
):
    """
    Silently create v1 notifications for all family members.
    This function only writes to the database - no external push notifications are sent.
    
    Args:
        family_id: The family ID to create notifications for
        notification_type: Type of notification (e.g., "recipe_added", "comment_added", "photo_added")
        payload: Light metadata dictionary (e.g., {"recipe_id": "...", "author_name": "..."})
        exclude_user_id: Optional user ID to exclude from notifications (e.g., the author)
    """
    if not family_id:
        # Don't create notifications if there's no family
        return
    
    # Get all family members
    query = {"family_id": family_id}
    if exclude_user_id:
        query["id"] = {"$ne": exclude_user_id}
    
    family_members = await db.users.find(
        query,
        {"_id": 0, "id": 1}
    ).to_list(100)
    
    if not family_members:
        return
    
    # Create notification records for each family member
    notifications = []
    for member in family_members:
        notification_doc = {
            "id": str(uuid.uuid4()),
            "user_id": member["id"],
            "family_id": family_id,
            "type": notification_type,
            "payload": payload,
            "is_read": False,
            "created_at": datetime.now(timezone.utc).isoformat()
        }
        notifications.append(notification_doc)
    
    # Insert all notifications silently (no external push)
    if notifications:
        await db.notifications_v1.insert_many(notifications)

# ===================== AUTH ROUTES =====================

@api_router.post("/auth/register", response_model=TokenResponse)
async def register(user_data: UserCreate):
    # Check if user exists
    existing = await db.users.find_one({"email": user_data.email.lower()})
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Create user
    user_id = str(uuid.uuid4())
    initial_credits = get_credits_for_tier(None)  # Free tier credits
    credits_refresh = next_refresh_date()
    user_doc = {
        "id": user_id,
        "name": user_data.name,
        "nickname": user_data.nickname,
        "email": user_data.email.lower(),
        "password_hash": hash_password(user_data.password),
        "avatar": None,
        "credits_balance": initial_credits,
        "credits_refresh_at": credits_refresh,
        "created_at": datetime.now(timezone.utc).isoformat()
    }
    await db.users.insert_one(user_doc)

    token = create_token(user_id)
    user_response = UserResponse(
        id=user_id,
        name=user_data.name,
        nickname=user_data.nickname,
        email=user_data.email.lower(),
        avatar=None,
        family_id=None,  # New users start without a family
        role=None,        # New users start without a role
        credits_balance=initial_credits,
        credits_refresh_at=credits_refresh,
        created_at=user_doc["created_at"]
    )
    return TokenResponse(token=token, user=user_response)

@api_router.post("/auth/login", response_model=TokenResponse)
async def login(credentials: UserLogin):
    user = await db.users.find_one({"email": credentials.email.lower()}, {"_id": 0})
    if not user:
        raise HTTPException(status_code=401, detail="Invalid email or password")
    if not user.get("password_hash"):
        raise HTTPException(status_code=400, detail="This account uses Google Sign-In. Please sign in with Google.")
    if not verify_password(credentials.password, user["password_hash"]):
        raise HTTPException(status_code=401, detail="Invalid email or password")
    
    # Auto-refresh credits if needed
    user = await refresh_credits_if_needed(user)
    token = create_token(user["id"])
    user_response = UserResponse(
        id=user["id"],
        name=user["name"],
        nickname=user.get("nickname"),
        email=user["email"],
        avatar=user.get("avatar"),
        family_id=user.get("family_id"),
        role=user.get("role"),
        subscription_tier=user.get("subscription_tier"),
        credits_balance=user.get("credits_balance", 0),
        credits_refresh_at=user.get("credits_refresh_at"),
        created_at=user["created_at"]
    )
    return TokenResponse(token=token, user=user_response)

@api_router.post("/auth/google", response_model=TokenResponse)
async def google_auth(body: GoogleAuthRequest):
    """Verify Google ID token and login or register the user."""
    google_client_id = os.environ.get("GOOGLE_CLIENT_ID")
    if not google_client_id:
        raise HTTPException(status_code=500, detail="Google auth not configured")

    # Verify the ID token with Google
    async with httpx.AsyncClient() as http_client:
        resp = await http_client.get(
            f"https://oauth2.googleapis.com/tokeninfo?id_token={body.credential}"
        )
    if resp.status_code != 200:
        raise HTTPException(status_code=401, detail="Invalid Google token")

    google_info = resp.json()
    # Verify audience matches our client ID
    if google_info.get("aud") != google_client_id:
        raise HTTPException(status_code=401, detail="Token audience mismatch")

    email = google_info["email"].lower()
    name = google_info.get("name", email.split("@")[0])
    picture = google_info.get("picture")

    # Check if user exists
    user = await db.users.find_one({"email": email}, {"_id": 0})

    if user:
        # Existing user — log them in
        user = await refresh_credits_if_needed(user)
        token = create_token(user["id"])
        user_response = UserResponse(
            id=user["id"],
            name=user["name"],
            nickname=user.get("nickname"),
            email=user["email"],
            avatar=user.get("avatar"),
            family_id=user.get("family_id"),
            role=user.get("role"),
            subscription_tier=user.get("subscription_tier"),
            credits_balance=user.get("credits_balance", 0),
            credits_refresh_at=user.get("credits_refresh_at"),
            created_at=user["created_at"]
        )
    else:
        # New user — register with Google info (no password)
        user_id = str(uuid.uuid4())
        initial_credits = get_credits_for_tier(None)
        credits_refresh = next_refresh_date()
        user_doc = {
            "id": user_id,
            "name": name,
            "nickname": None,
            "email": email,
            "password_hash": None,  # Google users have no password
            "avatar": picture,
            "auth_provider": "google",
            "credits_balance": initial_credits,
            "credits_refresh_at": credits_refresh,
            "created_at": datetime.now(timezone.utc).isoformat()
        }
        await db.users.insert_one(user_doc)
        token = create_token(user_id)
        user_response = UserResponse(
            id=user_id,
            name=name,
            nickname=None,
            email=email,
            avatar=picture,
            family_id=None,
            role=None,
            credits_balance=initial_credits,
            credits_refresh_at=credits_refresh,
            created_at=user_doc["created_at"]
        )

    return TokenResponse(token=token, user=user_response)

@api_router.get("/auth/me", response_model=UserResponse)
async def get_me(user: dict = Depends(get_current_user)):
    # Auto-refresh credits if needed
    user = await refresh_credits_if_needed(user)
    return UserResponse(
        id=user["id"],
        name=user["name"],
        nickname=user.get("nickname"),
        email=user["email"],
        avatar=user.get("avatar"),
        family_id=user.get("family_id"),
        role=user.get("role"),
        subscription_tier=user.get("subscription_tier"),
        credits_balance=user.get("credits_balance", 0),
        credits_refresh_at=user.get("credits_refresh_at"),
        created_at=user["created_at"]
    )

@api_router.put("/auth/profile", response_model=UserResponse)
async def update_profile(update_data: UserUpdate, user: dict = Depends(get_current_user)):
    update_fields = {}
    if update_data.nickname is not None:
        update_fields["nickname"] = update_data.nickname if update_data.nickname.strip() else None
    if update_data.avatar is not None:
        update_fields["avatar"] = update_data.avatar if update_data.avatar else None
    
    if update_fields:
        await db.users.update_one({"id": user["id"]}, {"$set": update_fields})
    
    updated_user = await db.users.find_one({"id": user["id"]}, {"_id": 0})
    return UserResponse(
        id=updated_user["id"],
        name=updated_user["name"],
        nickname=updated_user.get("nickname"),
        email=updated_user["email"],
        avatar=updated_user.get("avatar"),
        family_id=updated_user.get("family_id"),
        role=updated_user.get("role"),
        subscription_tier=updated_user.get("subscription_tier"),
        credits_balance=updated_user.get("credits_balance", 0),
        credits_refresh_at=updated_user.get("credits_refresh_at"),
        created_at=updated_user["created_at"]
    )

# ===================== RECIPE ROUTES =====================

@api_router.post("/recipes", response_model=RecipeResponse)
async def create_recipe(recipe_data: RecipeCreate, user: dict = Depends(get_current_user)):
    # Backward compatible: Allow recipe creation even without family
    user_family_id = user.get("family_id")
    
    recipe_id = str(uuid.uuid4())
    display_name = user.get("nickname") or user["name"]
    recipe_doc = {
        "id": recipe_id,
        "family_id": user_family_id,  # Will be None if user has no family (legacy recipe)
        "title": recipe_data.title,
        "ingredients": recipe_data.ingredients,
        "instructions": recipe_data.instructions,
        "story": recipe_data.story,
        "photos": recipe_data.photos,
        "cooking_time": recipe_data.cooking_time,
        "servings": recipe_data.servings,
        "category": recipe_data.category,
        "difficulty": recipe_data.difficulty,
        "author_id": user["id"],
        "author_name": display_name,
        "created_at": datetime.now(timezone.utc).isoformat()
    }
    await db.recipes.insert_one(recipe_doc)
    
    # Create notifications only if user has a family
    if user_family_id:
        family_members = await db.users.find(
            {"family_id": user_family_id, "id": {"$ne": user["id"]}},
            {"_id": 0, "id": 1}
        ).to_list(100)
        
        notifications = []
        for member in family_members:
            notification_doc = {
                "id": str(uuid.uuid4()),
                "user_id": member["id"],
                "type": "new_recipe",
                "message": f"{display_name} shared a new recipe: {recipe_data.title}",
                "recipe_id": recipe_id,
                "from_user_name": display_name,
                "is_read": False,
                "created_at": datetime.now(timezone.utc).isoformat()
            }
            notifications.append(notification_doc)
        
        if notifications:
            await db.notifications.insert_many(notifications)
    
    # Create v1 notifications silently (new notification system)
    if user_family_id:
        await create_notification_v1(
            family_id=user_family_id,
            notification_type="recipe_added",
            payload={
                "recipe_id": recipe_id,
                "author_name": display_name,
                "recipe_title": recipe_data.title
            },
            exclude_user_id=user["id"]
        )
    
    return RecipeResponse(**{k: v for k, v in recipe_doc.items() if k != "_id"})

@api_router.get("/recipes", response_model=List[RecipeResponse])
async def get_recipes(
    category: Optional[str] = None,
    author_id: Optional[str] = None,
    user: dict = Depends(get_current_user)
):
    # Backward compatible: Handle both family-scoped and legacy recipes
    user_family_id = user.get("family_id")
    
    if user_family_id:
        # User has a family: show family-scoped recipes only
        query = {"family_id": user_family_id}
    else:
        # User has no family: show legacy recipes (family_id is null)
        query = {"family_id": None}
    
    # Apply filters
    if category:
        query["category"] = category
    if author_id:
        query["author_id"] = author_id
    
    recipes = await db.recipes.find(query, {"_id": 0}).sort("created_at", -1).to_list(100)
    return [RecipeResponse(**r) for r in recipes]

@api_router.get("/recipes/{recipe_id}", response_model=RecipeResponse)
async def get_recipe(recipe_id: str, user: dict = Depends(get_current_user)):
    recipe = await db.recipes.find_one({"id": recipe_id}, {"_id": 0})
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    
    recipe_family_id = recipe.get("family_id")
    user_family_id = user.get("family_id")
    
    # Backward compatible access control:
    # 1. Legacy recipes (family_id is None): accessible to everyone
    # 2. Family-scoped recipes: only accessible to family members
    if recipe_family_id is None:
        # Legacy recipe: accessible to all users
        pass
    elif recipe_family_id != user_family_id:
        # Family-scoped recipe: user must be in the same family
        raise HTTPException(status_code=403, detail="Not authorized to view this recipe")
    
    return RecipeResponse(**recipe)

@api_router.put("/recipes/{recipe_id}", response_model=RecipeResponse)
async def update_recipe(recipe_id: str, recipe_data: RecipeUpdate, user: dict = Depends(get_current_user)):
    recipe = await db.recipes.find_one({"id": recipe_id}, {"_id": 0})
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    
    # Check authorization: only author can update
    if recipe["author_id"] != user["id"]:
        raise HTTPException(status_code=403, detail="Not authorized to update this recipe")
    
    # Backward compatible: Check family access for family-scoped recipes
    recipe_family_id = recipe.get("family_id")
    user_family_id = user.get("family_id")
    
    if recipe_family_id is not None and recipe_family_id != user_family_id:
        raise HTTPException(status_code=403, detail="Not authorized to update this recipe")
    
    # Check if photos are being added (for v1 notification)
    photos_added = False
    old_photos = recipe.get("photos", [])
    if recipe_data.photos is not None:
        new_photos = recipe_data.photos
        # Check if new photos list is longer than old photos list
        if len(new_photos) > len(old_photos):
            photos_added = True
    
    update_data = {k: v for k, v in recipe_data.model_dump().items() if v is not None}
    if update_data:
        await db.recipes.update_one({"id": recipe_id}, {"$set": update_data})
    
    updated = await db.recipes.find_one({"id": recipe_id}, {"_id": 0})
    
    # Create v1 notification for photo_added event (silent)
    if photos_added and recipe_family_id:
        display_name = user.get("nickname") or user["name"]
        await create_notification_v1(
            family_id=recipe_family_id,
            notification_type="photo_added",
            payload={
                "recipe_id": recipe_id,
                "recipe_title": recipe.get("title", ""),
                "author_name": display_name,
                "photo_count": len(updated.get("photos", []))
            },
            exclude_user_id=user["id"]  # Don't notify the recipe author
        )
    
    return RecipeResponse(**updated)

@api_router.delete("/recipes/{recipe_id}")
async def delete_recipe(recipe_id: str, user: dict = Depends(get_current_user)):
    recipe = await db.recipes.find_one({"id": recipe_id}, {"_id": 0})
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    
    recipe_family_id = recipe.get("family_id")
    user_family_id = user.get("family_id")
    
    # Backward compatible access control:
    # 1. Legacy recipes (family_id is None): only author can delete
    # 2. Family-scoped recipes: author can always delete, keeper can delete any
    if recipe_family_id is None:
        # Legacy recipe: only author can delete
        if recipe["author_id"] != user["id"]:
            raise HTTPException(status_code=403, detail="Not authorized to delete this recipe")
    else:
        # Family-scoped recipe: check family membership
        if recipe_family_id != user_family_id:
            raise HTTPException(status_code=403, detail="Not authorized")
        
        # Role-based deletion: Keeper can delete any, Member can only delete own
        if recipe["author_id"] != user["id"] and user.get("role") != "keeper":
            raise HTTPException(status_code=403, detail="Only keepers can delete others' recipes")
    
    await db.recipes.delete_one({"id": recipe_id})
    return {"message": "Recipe deleted successfully"}

@api_router.get("/categories", response_model=List[str])
async def get_categories():
    categories = await db.recipes.distinct("category")
    default_categories = ["Main Course", "Appetizer", "Dessert", "Soup", "Salad", "Breakfast", "Snack", "Beverage"]
    all_cats = list(set(default_categories + categories))
    return sorted(all_cats)

# ===================== COMMENT ROUTES =====================

@api_router.post("/recipes/{recipe_id}/comments", response_model=CommentResponse)
async def create_comment(recipe_id: str, comment_data: CommentCreate, user: dict = Depends(get_current_user)):
    # Verify recipe exists
    recipe = await db.recipes.find_one({"id": recipe_id})
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    
    comment_id = str(uuid.uuid4())
    display_name = user.get("nickname") or user["name"]
    comment_doc = {
        "id": comment_id,
        "recipe_id": recipe_id,
        "user_id": user["id"],
        "user_name": display_name,
        "text": comment_data.text,
        "created_at": datetime.now(timezone.utc).isoformat()
    }
    await db.comments.insert_one(comment_doc)
    
    # Create notification for recipe author if they're in a family and it's not their own comment
    if recipe["author_id"] != user["id"]:
        recipe_family_id = recipe.get("family_id")
        if recipe_family_id:
            # Check if recipe author is in the same family
            author = await db.users.find_one({"id": recipe["author_id"]}, {"_id": 0})
            if author and author.get("family_id") == recipe_family_id:
                notification_doc = {
                    "id": str(uuid.uuid4()),
                    "user_id": recipe["author_id"],
                    "type": "comment",
                    "message": f"{display_name} commented on your recipe: {recipe['title']}",
                    "recipe_id": recipe_id,
                    "from_user_name": display_name,
                    "is_read": False,
                    "created_at": datetime.now(timezone.utc).isoformat()
                }
                await db.notifications.insert_one(notification_doc)
    
    # Create v1 notifications silently (new notification system)
    recipe_family_id = recipe.get("family_id")
    if recipe_family_id:
        # Notify all family members about the new comment
        await create_notification_v1(
            family_id=recipe_family_id,
            notification_type="comment_added",
            payload={
                "recipe_id": recipe_id,
                "recipe_title": recipe.get("title", ""),
                "comment_author_name": display_name,
                "comment_id": comment_id
            },
            exclude_user_id=user["id"]  # Don't notify the comment author
        )
    
    return CommentResponse(**{k: v for k, v in comment_doc.items() if k != "_id"})

@api_router.get("/recipes/{recipe_id}/comments", response_model=List[CommentResponse])
async def get_comments(recipe_id: str):
    comments = await db.comments.find({"recipe_id": recipe_id}, {"_id": 0}).sort("created_at", -1).to_list(100)
    return [CommentResponse(**c) for c in comments]

@api_router.delete("/comments/{comment_id}")
async def delete_comment(comment_id: str, user: dict = Depends(get_current_user)):
    comment = await db.comments.find_one({"id": comment_id}, {"_id": 0})
    if not comment:
        raise HTTPException(status_code=404, detail="Comment not found")
    if comment["user_id"] != user["id"]:
        raise HTTPException(status_code=403, detail="Not authorized to delete this comment")
    
    await db.comments.delete_one({"id": comment_id})
    return {"message": "Comment deleted successfully"}

# ===================== NOTIFICATION ROUTES =====================

@api_router.get("/notifications", response_model=List[NotificationResponse])
async def get_notifications(user: dict = Depends(get_current_user)):
    notifications = await db.notifications.find(
        {"user_id": user["id"]}, 
        {"_id": 0}
    ).sort("created_at", -1).to_list(50)
    return [NotificationResponse(**n) for n in notifications]

@api_router.get("/notifications/unread-count")
async def get_unread_count(user: dict = Depends(get_current_user)):
    count = await db.notifications.count_documents({"user_id": user["id"], "is_read": False})
    return {"count": count}

@api_router.put("/notifications/{notification_id}/read")
async def mark_notification_read(notification_id: str, user: dict = Depends(get_current_user)):
    result = await db.notifications.update_one(
        {"id": notification_id, "user_id": user["id"]},
        {"$set": {"is_read": True}}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Notification not found")
    return {"message": "Notification marked as read"}

@api_router.put("/notifications/read-all")
async def mark_all_notifications_read(user: dict = Depends(get_current_user)):
    await db.notifications.update_many(
        {"user_id": user["id"], "is_read": False},
        {"$set": {"is_read": True}}
    )
    return {"message": "All notifications marked as read"}

# ===================== FAMILY ROUTES =====================

@api_router.post("/families", response_model=FamilyResponse)
async def create_family(family_data: FamilyCreate, user: dict = Depends(get_current_user)):
    # Check if user already has a family
    if user.get("family_id"):
        raise HTTPException(status_code=400, detail="User already belongs to a family")
    
    # Generate unique invite code
    invite_code = str(uuid.uuid4())[:8].upper()
    
    # Ensure invite code is unique
    while await db.families.find_one({"invite_code": invite_code}):
        invite_code = str(uuid.uuid4())[:8].upper()
    
    family_id = str(uuid.uuid4())
    family_doc = {
        "id": family_id,
        "name": family_data.name,
        "owner_id": user["id"],
        "invite_code": invite_code,
        "metadata": {
            "description": family_data.description
        } if family_data.description else None,
        "created_at": datetime.now(timezone.utc).isoformat()
    }
    await db.families.insert_one(family_doc)
    
    # Update user to be keeper of this family
    await db.users.update_one(
        {"id": user["id"]},
        {"$set": {"family_id": family_id, "role": "keeper"}}
    )
    
    return FamilyResponse(**{k: v for k, v in family_doc.items() if k != "_id"})

@api_router.post("/families/join", response_model=FamilyResponse)
async def join_family(join_data: FamilyJoinRequest, user: dict = Depends(get_current_user)):
    # Check if user already has a family
    if user.get("family_id"):
        raise HTTPException(status_code=400, detail="User already belongs to a family")
    
    # Find family by invite code
    family = await db.families.find_one({"invite_code": join_data.invite_code.upper()}, {"_id": 0})
    if not family:
        raise HTTPException(status_code=404, detail="Invalid invite code")
    
    # Update user to be member of this family
    await db.users.update_one(
        {"id": user["id"]},
        {"$set": {"family_id": family["id"], "role": "member"}}
    )
    
    # Create notification for family keeper
    keeper = await db.users.find_one({"id": family["owner_id"]}, {"_id": 0})
    if keeper:
        display_name = user.get("nickname") or user["name"]
        notification_doc = {
            "id": str(uuid.uuid4()),
            "user_id": family["owner_id"],
            "type": "family_invite",
            "message": f"{display_name} joined your family: {family['name']}",
            "from_user_name": display_name,
            "is_read": False,
            "created_at": datetime.now(timezone.utc).isoformat()
        }
        await db.notifications.insert_one(notification_doc)
    
    return FamilyResponse(**family)

@api_router.get("/families/{family_id}", response_model=FamilyResponse)
async def get_family(family_id: str, user: dict = Depends(get_current_user)):
    # Verify user belongs to this family
    if user.get("family_id") != family_id:
        raise HTTPException(status_code=403, detail="Not a member of this family")
    
    family = await db.families.find_one({"id": family_id}, {"_id": 0})
    if not family:
        raise HTTPException(status_code=404, detail="Family not found")
    
    return FamilyResponse(**family)

@api_router.put("/families/{family_id}", response_model=FamilyResponse)
async def update_family(family_id: str, family_data: FamilyUpdate, user: dict = Depends(get_current_user)):
    # Verify user belongs to this family and is the keeper
    if user.get("family_id") != family_id:
        raise HTTPException(status_code=403, detail="Not a member of this family")
    
    if user.get("role") != "keeper":
        raise HTTPException(status_code=403, detail="Only the family keeper can update the family")
    
    family = await db.families.find_one({"id": family_id}, {"_id": 0})
    if not family:
        raise HTTPException(status_code=404, detail="Family not found")
    
    # Build update fields
    update_fields = {}
    if family_data.name is not None:
        update_fields["name"] = family_data.name
    
    # Handle metadata updates
    metadata_updates = {}
    if family_data.description is not None:
        metadata_updates["description"] = family_data.description
    if family_data.cover_image is not None:
        metadata_updates["cover_image"] = family_data.cover_image
    
    # Update metadata if needed
    if metadata_updates:
        current_metadata = family.get("metadata") or {}
        updated_metadata = {**current_metadata, **metadata_updates}
        update_fields["metadata"] = updated_metadata
    
    # Apply updates
    if update_fields:
        await db.families.update_one({"id": family_id}, {"$set": update_fields})
    
    updated_family = await db.families.find_one({"id": family_id}, {"_id": 0})
    return FamilyResponse(**updated_family)

@api_router.delete("/families/{family_id}")
async def delete_family(family_id: str, user: dict = Depends(get_current_user)):
    # Verify user belongs to this family and is the keeper
    if user.get("family_id") != family_id:
        raise HTTPException(status_code=403, detail="Not a member of this family")
    
    if user.get("role") != "keeper":
        raise HTTPException(status_code=403, detail="Only the family keeper can delete the family")
    
    family = await db.families.find_one({"id": family_id}, {"_id": 0})
    if not family:
        raise HTTPException(status_code=404, detail="Family not found")
    
    # Remove all family members' family associations
    await db.users.update_many(
        {"family_id": family_id},
        {"$unset": {"family_id": "", "role": ""}}
    )
    
    # Delete the family
    await db.families.delete_one({"id": family_id})
    
    return {"message": "Family deleted successfully. All members have been removed from the family."}

@api_router.get("/families/{family_id}/members", response_model=List[FamilyMemberResponse])
async def get_family_members(family_id: str, user: dict = Depends(get_current_user)):
    # Verify user belongs to this family
    if user.get("family_id") != family_id:
        raise HTTPException(status_code=403, detail="Not a member of this family")
    
    # Verify family exists
    family = await db.families.find_one({"id": family_id}, {"_id": 0})
    if not family:
        raise HTTPException(status_code=404, detail="Family not found")
    
    # Get all family members
    members = await db.users.find(
        {"family_id": family_id},
        {"_id": 0, "id": 1, "name": 1, "nickname": 1, "email": 1, "avatar": 1, "role": 1, "created_at": 1}
    ).to_list(100)
    
    # Convert to response model
    member_responses = []
    for member in members:
        member_responses.append(FamilyMemberResponse(
            id=member["id"],
            name=member["name"],
            nickname=member.get("nickname"),
            email=member["email"],
            avatar=member.get("avatar"),
            role=member.get("role", "member"),
            joined_at=member.get("created_at")  # Using created_at as proxy for joined_at
        ))
    
    return member_responses

@api_router.delete("/families/{family_id}/members/{user_id}")
async def remove_family_member(family_id: str, user_id: str, user: dict = Depends(get_current_user)):
    # Verify user belongs to this family and is the keeper
    if user.get("family_id") != family_id:
        raise HTTPException(status_code=403, detail="Not a member of this family")
    
    if user.get("role") != "keeper":
        raise HTTPException(status_code=403, detail="Only the family keeper can remove members")
    
    # Verify family exists
    family = await db.families.find_one({"id": family_id}, {"_id": 0})
    if not family:
        raise HTTPException(status_code=404, detail="Family not found")
    
    # Prevent keeper from removing themselves
    if user_id == user["id"]:
        raise HTTPException(status_code=400, detail="Keeper cannot remove themselves. Delete the family instead.")
    
    # Verify the member exists and belongs to this family
    member = await db.users.find_one({"id": user_id, "family_id": family_id}, {"_id": 0})
    if not member:
        raise HTTPException(status_code=404, detail="Member not found or does not belong to this family")
    
    # Remove member from family
    await db.users.update_one(
        {"id": user_id},
        {"$unset": {"family_id": "", "role": ""}}
    )
    
    # Create notification for removed member
    display_name = user.get("nickname") or user["name"]
    notification_doc = {
        "id": str(uuid.uuid4()),
        "user_id": user_id,
        "type": "family_invite",
        "message": f"You have been removed from {family['name']} by {display_name}",
        "from_user_name": display_name,
        "is_read": False,
        "created_at": datetime.now(timezone.utc).isoformat()
    }
    await db.notifications.insert_one(notification_doc)
    
    return {"message": "Member removed from family successfully"}

@api_router.delete("/families/{family_id}/leave")
async def leave_family(family_id: str, user: dict = Depends(get_current_user)):
    """
    Allow a member to leave the family themselves.
    - Regular members can leave immediately
    - Keeper can only leave if they are the only member, or after transferring keeper role
    """
    # Verify user belongs to this family
    if user.get("family_id") != family_id:
        raise HTTPException(status_code=403, detail="Not a member of this family")
    
    # Verify family exists
    family = await db.families.find_one({"id": family_id}, {"_id": 0})
    if not family:
        raise HTTPException(status_code=404, detail="Family not found")
    
    user_role = user.get("role")
    is_keeper = user_role == "keeper"
    
    # Check if user is the keeper
    if is_keeper:
        # Count total members in the family
        member_count = await db.users.count_documents({"family_id": family_id})
        
        if member_count > 1:
            # Keeper cannot leave if there are other members
            raise HTTPException(
                status_code=400,
                detail="Keeper cannot leave the family while other members exist. Please transfer the keeper role first or remove other members."
            )
        # If keeper is the only member, they can leave (family will be empty)
    
    # Remove user from family
    await db.users.update_one(
        {"id": user["id"]},
        {"$unset": {"family_id": "", "role": ""}}
    )
    
    # If keeper was the only member and left, optionally delete the family
    # Or keep it for potential future members (your choice)
    # For now, we'll keep the family but it will have no members
    
    # Create notification for family keeper (if there is one and it's not the leaving user)
    if not is_keeper and family.get("owner_id") != user["id"]:
        display_name = user.get("nickname") or user["name"]
        notification_doc = {
            "id": str(uuid.uuid4()),
            "user_id": family["owner_id"],
            "type": "family_invite",
            "message": f"{display_name} left your family: {family['name']}",
            "from_user_name": display_name,
            "is_read": False,
            "created_at": datetime.now(timezone.utc).isoformat()
        }
        await db.notifications.insert_one(notification_doc)
    
    return {"message": "Successfully left the family"}

@api_router.put("/families/{family_id}/transfer-keeper")
async def transfer_keeper(
    family_id: str,
    transfer_data: FamilyTransferKeeperRequest,
    user: dict = Depends(get_current_user)
):
    """
    Transfer the keeper role from the current keeper to another member.
    Only the current keeper can transfer their role.
    """
    # Verify user belongs to this family and is the keeper
    if user.get("family_id") != family_id:
        raise HTTPException(status_code=403, detail="Not a member of this family")
    
    if user.get("role") != "keeper":
        raise HTTPException(
            status_code=403,
            detail="Only the family keeper can transfer the keeper role"
        )
    
    # Verify family exists
    family = await db.families.find_one({"id": family_id}, {"_id": 0})
    if not family:
        raise HTTPException(status_code=404, detail="Family not found")
    
    # Prevent transferring to yourself
    if transfer_data.new_keeper_id == user["id"]:
        raise HTTPException(
            status_code=400,
            detail="Cannot transfer keeper role to yourself"
        )
    
    # Verify the new keeper exists and is a member of this family
    new_keeper = await db.users.find_one(
        {"id": transfer_data.new_keeper_id, "family_id": family_id},
        {"_id": 0}
    )
    if not new_keeper:
        raise HTTPException(
            status_code=404,
            detail="New keeper not found or is not a member of this family"
        )
    
    # Transfer keeper role
    # 1. Update family owner_id to new keeper
    await db.families.update_one(
        {"id": family_id},
        {"$set": {"owner_id": transfer_data.new_keeper_id}}
    )
    
    # 2. Update new keeper's role to "keeper"
    await db.users.update_one(
        {"id": transfer_data.new_keeper_id},
        {"$set": {"role": "keeper"}}
    )
    
    # 3. Update old keeper's role to "member"
    await db.users.update_one(
        {"id": user["id"]},
        {"$set": {"role": "member"}}
    )
    
    # Create notifications
    old_keeper_name = user.get("nickname") or user["name"]
    new_keeper_name = new_keeper.get("nickname") or new_keeper["name"]
    
    # Notify new keeper
    notification_doc_new = {
        "id": str(uuid.uuid4()),
        "user_id": transfer_data.new_keeper_id,
        "type": "family_invite",
        "message": f"You are now the keeper of {family['name']}",
        "from_user_name": old_keeper_name,
        "is_read": False,
        "created_at": datetime.now(timezone.utc).isoformat()
    }
    await db.notifications.insert_one(notification_doc_new)
    
    # Notify other family members (optional - you can skip this if not needed)
    other_members = await db.users.find(
        {
            "family_id": family_id,
            "id": {"$nin": [user["id"], transfer_data.new_keeper_id]}
        },
        {"_id": 0, "id": 1}
    ).to_list(100)
    
    if other_members:
        notifications = []
        for member in other_members:
            notification_doc = {
                "id": str(uuid.uuid4()),
                "user_id": member["id"],
                "type": "family_invite",
                "message": f"{new_keeper_name} is now the keeper of {family['name']}",
                "from_user_name": old_keeper_name,
                "is_read": False,
                "created_at": datetime.now(timezone.utc).isoformat()
            }
            notifications.append(notification_doc)
        
        if notifications:
            await db.notifications.insert_many(notifications)
    
    return {"message": f"Keeper role successfully transferred to {new_keeper_name}"}

# ===================== DELETE ACCOUNT =====================

@api_router.post("/delete-account")
async def delete_account_request(body: DeleteAccountRequest):
    """Store account deletion request for processing."""
    doc = {
        "id": str(uuid.uuid4()),
        "email": body.email.lower(),
        "status": "pending",
        "requested_at": datetime.now(timezone.utc).isoformat(),
    }
    await db.accountDeletionRequests.insert_one(doc)
    logger.info("Account deletion request received for email=%s", body.email.lower())
    return {"message": "Deletion request received. We will process it shortly."}

# ===================== SUBSCRIPTIONS =====================

import hmac
import hashlib

# Stripe price ID → subscription tier mapping
STRIPE_PRICE_TIERS = {
    "price_1TCNF2Ak1UyEdCJUJKEmydMm": "heritage",  # Heritage Keeper Monthly
    "price_1TCMgEAk1UyEdCJUozc8nt8L": "heritage",  # Heritage Keeper Annual
    "price_1TCND7Ak1UyEdCJUQCBO5leT": "legacy",    # Legacy Collection Monthly
    "price_1TCMiqAk1UyEdCJUomu9wkct": "legacy",    # Legacy Collection Annual
}

# RevenueCat product ID → subscription tier mapping
RC_PRODUCT_TIERS = {
    "com.htrecipes.familyRecipeApp.keeper.monthly":    "heritage",
    "com.htrecipes.familyRecipeApp.keeper.annual":     "heritage",
    "com.htrecipes.familyRecipeApp.collection.monthly": "legacy",
    "com.htrecipes.familyRecipeApp.collection.annual":  "legacy",
}

# RevenueCat events that mean the subscription is active
RC_ACTIVE_EVENTS = {"INITIAL_PURCHASE", "RENEWAL", "PRODUCT_CHANGE", "UNCANCELLATION"}
# RevenueCat events that mean the subscription ended
RC_INACTIVE_EVENTS = {"CANCELLATION", "EXPIRATION", "SUBSCRIBER_ALIAS", "BILLING_ISSUE"}


class SubscriptionStatusResponse(BaseModel):
    subscription_tier: Optional[str] = None  # "heritage" | "legacy" | None
    is_active: bool
    credits_balance: int = 0
    credits_refresh_at: Optional[str] = None
    monthly_allowance: int = 3


@api_router.get("/subscriptions/status", response_model=SubscriptionStatusResponse)
async def get_subscription_status(user: dict = Depends(get_current_user)):
    """Return the current user's subscription tier and credit info."""
    user = await refresh_credits_if_needed(user)
    tier = user.get("subscription_tier")
    return SubscriptionStatusResponse(
        subscription_tier=tier,
        is_active=tier is not None,
        credits_balance=user.get("credits_balance", 0),
        credits_refresh_at=user.get("credits_refresh_at"),
        monthly_allowance=get_credits_for_tier(tier),
    )


@api_router.post("/subscriptions/webhook/revenuecat")
async def revenuecat_webhook(request: Request):
    """
    Receive subscription lifecycle events from RevenueCat and update user tier.
    Set REVENUECAT_WEBHOOK_SECRET in your .env to validate incoming requests.
    """
    rc_secret = os.environ.get("REVENUECAT_WEBHOOK_SECRET", "")
    if rc_secret:
        auth_header = request.headers.get("Authorization", "")
        if auth_header != rc_secret:
            raise HTTPException(status_code=401, detail="Invalid webhook secret")

    try:
        payload = await request.json()
    except Exception:
        raise HTTPException(status_code=400, detail="Invalid JSON payload")

    event = payload.get("event", {})
    event_type = event.get("type", "")
    app_user_id = event.get("app_user_id", "")
    product_id = event.get("product_id", "")

    logger.info("RevenueCat webhook: type=%s user=%s product=%s", event_type, app_user_id, product_id)

    if not app_user_id:
        return {"status": "ignored", "reason": "no app_user_id"}

    if event_type in RC_ACTIVE_EVENTS:
        tier = RC_PRODUCT_TIERS.get(product_id)
        if tier:
            new_credits = get_credits_for_tier(tier)
            await db.users.update_one(
                {"id": app_user_id},
                {"$set": {
                    "subscription_tier": tier,
                    "credits_balance": new_credits,
                    "credits_refresh_at": next_refresh_date(),
                }}
            )
            logger.info("Set subscription_tier=%s credits=%d for user=%s", tier, new_credits, app_user_id)

    elif event_type in RC_INACTIVE_EVENTS:
        free_credits = get_credits_for_tier(None)
        await db.users.update_one(
            {"id": app_user_id},
            {
                "$unset": {"subscription_tier": ""},
                "$set": {
                    "credits_balance": free_credits,
                    "credits_refresh_at": next_refresh_date(),
                }
            }
        )
        logger.info("Cleared subscription_tier, reset to %d free credits for user=%s", free_credits, app_user_id)

    return {"status": "ok"}


@api_router.post("/subscriptions/webhook/stripe")
async def stripe_webhook(request: Request):
    """
    Receive Stripe subscription events and update user tier.
    Requires STRIPE_SECRET_KEY and STRIPE_WEBHOOK_SECRET in .env.
    """
    stripe_secret = os.environ.get("STRIPE_SECRET_KEY", "")
    webhook_secret = os.environ.get("STRIPE_WEBHOOK_SECRET", "")

    if not stripe_secret or not webhook_secret:
        logger.warning("Stripe env vars not configured — webhook ignored")
        return {"status": "not_configured"}

    # Verify Stripe signature
    payload_bytes = await request.body()
    sig_header = request.headers.get("stripe-signature", "")

    try:
        import stripe as stripe_lib
        stripe_lib.api_key = stripe_secret
        event = stripe_lib.Webhook.construct_event(payload_bytes, sig_header, webhook_secret)
    except Exception as e:
        logger.error("Stripe webhook signature verification failed: %s", e)
        raise HTTPException(status_code=400, detail="Invalid Stripe signature")

    event_type = event["type"]
    subscription_obj = event["data"]["object"]

    logger.info("Stripe webhook: type=%s", event_type)

    if event_type in ("customer.subscription.created", "customer.subscription.updated"):
        status_val = subscription_obj.get("status", "")
        if status_val not in ("active", "trialing"):
            return {"status": "ignored", "reason": f"subscription status={status_val}"}

        # Get price ID from subscription items
        items = subscription_obj.get("items", {}).get("data", [])
        price_id = items[0]["price"]["id"] if items else None
        tier = STRIPE_PRICE_TIERS.get(price_id) if price_id else None

        # Match user by Stripe customer email
        customer_email = None
        try:
            customer = stripe_lib.Customer.retrieve(subscription_obj["customer"])
            customer_email = customer.get("email", "").lower()
        except Exception as e:
            logger.error("Could not retrieve Stripe customer: %s", e)

        if customer_email and tier:
            new_credits = get_credits_for_tier(tier)
            new_refresh = next_refresh_date()
            await db.users.update_one(
                {"email": customer_email},
                {"$set": {
                    "subscription_tier": tier,
                    "stripe_customer_id": subscription_obj["customer"],
                    "credits_balance": new_credits,
                    "credits_refresh_at": new_refresh,
                }}
            )
            logger.info("Set subscription_tier=%s credits=%d for email=%s", tier, new_credits, customer_email)

    elif event_type == "customer.subscription.deleted":
        customer_id = subscription_obj.get("customer")
        if customer_id:
            free_credits = get_credits_for_tier(None)
            await db.users.update_one(
                {"stripe_customer_id": customer_id},
                {
                    "$unset": {"subscription_tier": ""},
                    "$set": {
                        "credits_balance": free_credits,
                        "credits_refresh_at": next_refresh_date(),
                    }
                }
            )
            logger.info("Cleared subscription_tier, reset to %d free credits for stripe_customer=%s", free_credits, customer_id)

    return {"status": "ok"}


# ---- Stripe Checkout (web subscriptions) ----

class CheckoutRequest(BaseModel):
    price_id: str
    success_url: str = "https://legacytable.app/subscription/success"
    cancel_url: str = "https://legacytable.app/pricing"


@api_router.post("/subscriptions/create-checkout-session")
async def create_checkout_session(body: CheckoutRequest, user: dict = Depends(get_current_user)):
    """Create a Stripe Checkout Session for web subscription purchase."""
    stripe_secret = os.environ.get("STRIPE_SECRET_KEY", "")
    if not stripe_secret:
        raise HTTPException(status_code=500, detail="Stripe not configured")

    import stripe as stripe_lib
    stripe_lib.api_key = stripe_secret

    # Validate the price ID is one of our known subscription prices
    if body.price_id not in STRIPE_PRICE_TIERS:
        raise HTTPException(status_code=400, detail="Invalid price ID")

    # Reuse existing Stripe customer or create one
    customer_id = user.get("stripe_customer_id")
    if not customer_id:
        try:
            customer = stripe_lib.Customer.create(
                email=user.get("email", ""),
                metadata={"legacy_table_user_id": user.get("id", "")},
            )
            customer_id = customer.id
            await db.users.update_one(
                {"id": user["id"]},
                {"$set": {"stripe_customer_id": customer_id}},
            )
        except Exception as e:
            logger.error("Failed to create Stripe customer: %s", e)
            raise HTTPException(status_code=500, detail="Could not create customer")

    try:
        session = stripe_lib.checkout.Session.create(
            customer=customer_id,
            mode="subscription",
            line_items=[{"price": body.price_id, "quantity": 1}],
            success_url=body.success_url + "?session_id={CHECKOUT_SESSION_ID}",
            cancel_url=body.cancel_url,
            allow_promotion_codes=True,
        )
        return {"checkout_url": session.url}
    except Exception as e:
        logger.error("Failed to create checkout session: %s", e)
        raise HTTPException(status_code=500, detail="Could not create checkout session")


@api_router.post("/subscriptions/create-portal-session")
async def create_portal_session(user: dict = Depends(get_current_user)):
    """Create a Stripe Customer Portal session so users can manage their subscription."""
    stripe_secret = os.environ.get("STRIPE_SECRET_KEY", "")
    if not stripe_secret:
        raise HTTPException(status_code=500, detail="Stripe not configured")

    import stripe as stripe_lib
    stripe_lib.api_key = stripe_secret

    customer_id = user.get("stripe_customer_id")
    if not customer_id:
        raise HTTPException(status_code=400, detail="No active subscription found")

    try:
        session = stripe_lib.billing_portal.Session.create(
            customer=customer_id,
            return_url="https://legacytable.app/settings",
        )
        return {"portal_url": session.url}
    except Exception as e:
        logger.error("Failed to create portal session: %s", e)
        raise HTTPException(status_code=500, detail="Could not create portal session")


# ===================== HEALTH CHECK =====================

# ---- Sample Family & Onboarding ----

SAMPLE_RECIPES = [
    {
        "title": "Grandma's Sunday Pot Roast",
        "ingredients": [
            "3 lb chuck roast", "4 carrots, chunked", "4 potatoes, quartered",
            "1 onion, quartered", "3 cloves garlic", "2 cups beef broth",
            "2 tbsp tomato paste", "1 tsp thyme", "Salt and pepper to taste",
            "2 tbsp olive oil"
        ],
        "instructions": (
            "Season the roast generously with salt and pepper. Heat olive oil in a Dutch oven over "
            "high heat and sear the roast on all sides until deeply browned, about 3-4 minutes per side. "
            "Remove the roast and add onion and garlic, cooking for 2 minutes. Stir in tomato paste and "
            "thyme, then pour in beef broth. Return the roast, bring to a simmer, cover and cook in a "
            "325°F oven for 2.5 hours. Add carrots and potatoes for the last 45 minutes. Rest 10 minutes "
            "before slicing. Serve with the vegetables and pan juices."
        ),
        "story": (
            "Every Sunday after church, Grandma would have this roast waiting. The whole house smelled "
            "like heaven. She always said the secret was patience — low and slow, just like love."
        ),
        "cooking_time": 180,
        "servings": 6,
        "category": "Main Dish",
        "difficulty": "medium",
    },
    {
        "title": "Auntie Mae's Sweet Potato Pie",
        "ingredients": [
            "2 large sweet potatoes", "1/2 cup butter, softened", "1 cup sugar",
            "1/2 cup milk", "2 eggs", "1 tsp vanilla extract",
            "1/2 tsp cinnamon", "1/4 tsp nutmeg", "1 unbaked 9-inch pie crust"
        ],
        "instructions": (
            "Boil sweet potatoes until tender, about 40 minutes. Drain, peel, and mash until smooth. "
            "Preheat oven to 350°F. Beat together sweet potatoes and butter until fluffy. Add sugar, "
            "milk, eggs, vanilla, cinnamon, and nutmeg — mix until well combined. Pour into pie crust. "
            "Bake for 55-60 minutes until a knife inserted in the center comes out clean. "
            "Cool completely before serving. Best with a dollop of whipped cream."
        ),
        "story": (
            "Auntie Mae brought this pie to every family gathering. She never wrote the recipe down — "
            "just pinches of this and handfuls of that. We finally got her to measure it out one "
            "Thanksgiving. Now it lives on for the next generation."
        ),
        "cooking_time": 100,
        "servings": 8,
        "category": "Dessert",
        "difficulty": "easy",
    },
    {
        "title": "Dad's Famous Jerk Chicken",
        "ingredients": [
            "8 chicken thighs", "6 scotch bonnet peppers, seeded", "1 bunch scallions",
            "4 cloves garlic", "2 tbsp soy sauce", "1 tbsp brown sugar",
            "2 tsp allspice", "1 tsp thyme", "1 tsp black pepper",
            "Juice of 2 limes", "2 tbsp vegetable oil"
        ],
        "instructions": (
            "Blend scotch bonnets, scallions, garlic, soy sauce, brown sugar, allspice, thyme, pepper, "
            "lime juice, and oil into a smooth marinade. Score chicken thighs with a knife and coat "
            "generously with marinade. Refrigerate for at least 4 hours, overnight is best. "
            "Grill over medium-high heat for 6-8 minutes per side until charred and cooked through "
            "(internal temp 165°F). Rest 5 minutes before serving with rice and peas."
        ),
        "story": (
            "Dad learned this from his father, who learned it from a cook in Kingston. He says the "
            "secret is the overnight marinade and real scotch bonnets — no substitutes. Every Fourth "
            "of July, the whole block lines up for a plate."
        ),
        "cooking_time": 30,
        "servings": 8,
        "category": "Main Dish",
        "difficulty": "medium",
    },
]


@api_router.post("/onboarding/seed-sample-family")
async def seed_sample_family(user: dict = Depends(get_current_user)):
    """
    Create a sample 'Legacy Family' with demo recipes for first-run users.
    Only works if the user is NOT already in a family.
    """
    if user.get("family_id"):
        raise HTTPException(status_code=400, detail="You are already in a family")

    # Check if user already seeded (idempotency)
    existing = await db.families.find_one({"created_by": user["id"], "is_sample": True})
    if existing:
        raise HTTPException(status_code=400, detail="Sample family already created")

    # Create the sample family
    family_id = str(uuid.uuid4())
    family_doc = {
        "id": family_id,
        "name": f"The {user['name'].split()[0]} Family" if user.get("name") else "My Family",
        "invite_code": str(uuid.uuid4())[:8].upper(),
        "created_by": user["id"],
        "keeper_id": user["id"],
        "is_sample": True,
        "created_at": datetime.now(timezone.utc).isoformat(),
    }
    await db.families.insert_one(family_doc)

    # Update user with family
    await db.users.update_one(
        {"id": user["id"]},
        {"$set": {"family_id": family_id, "role": "keeper"}}
    )

    # Seed sample recipes
    now = datetime.now(timezone.utc)
    for i, recipe_data in enumerate(SAMPLE_RECIPES):
        recipe_doc = {
            "id": str(uuid.uuid4()),
            "family_id": family_id,
            "title": recipe_data["title"],
            "ingredients": recipe_data["ingredients"],
            "instructions": recipe_data["instructions"],
            "story": recipe_data.get("story"),
            "photos": [],
            "cooking_time": recipe_data["cooking_time"],
            "servings": recipe_data["servings"],
            "category": recipe_data["category"],
            "difficulty": recipe_data["difficulty"],
            "author_id": user["id"],
            "author_name": user.get("name", "Family Chef"),
            "created_at": (now - timedelta(days=i)).isoformat(),
        }
        await db.recipes.insert_one(recipe_doc)

    logger.info("Seeded sample family=%s with %d recipes for user=%s", family_id, len(SAMPLE_RECIPES), user["id"])

    return {
        "family_id": family_id,
        "family_name": family_doc["name"],
        "recipes_created": len(SAMPLE_RECIPES),
        "message": "Welcome to Legacy Table! We've added some sample recipes to get you started.",
    }


# ---- Credits API ----

class CreditsResponse(BaseModel):
    credits_balance: int
    credits_refresh_at: Optional[str] = None
    tier: Optional[str] = None
    monthly_allowance: int


@api_router.get("/credits", response_model=CreditsResponse)
async def get_credits(user: dict = Depends(get_current_user)):
    """Return current credit balance, next refresh date, and tier info."""
    user = await refresh_credits_if_needed(user)
    tier = user.get("subscription_tier")
    return CreditsResponse(
        credits_balance=user.get("credits_balance", 0),
        credits_refresh_at=user.get("credits_refresh_at"),
        tier=tier,
        monthly_allowance=get_credits_for_tier(tier),
    )


class UseCreditsRequest(BaseModel):
    feature: str  # e.g. "recipe_scan", "voice_to_recipe"


class UseCreditsResponse(BaseModel):
    success: bool
    credits_remaining: int
    credits_used: int


@api_router.post("/credits/use", response_model=UseCreditsResponse)
async def use_credits(body: UseCreditsRequest, user: dict = Depends(get_current_user)):
    """Consume credits for an AI feature. Returns updated balance."""
    if body.feature not in CREDIT_COSTS:
        raise HTTPException(status_code=400, detail=f"Unknown feature: {body.feature}")

    cost = CREDIT_COSTS[body.feature]
    user = await consume_credit(user, body.feature)
    return UseCreditsResponse(
        success=True,
        credits_remaining=user.get("credits_balance", 0),
        credits_used=cost,
    )


@api_router.get("/")
async def root():
    return {"message": "Honor Touré Family Recipe API"}

@api_router.get("/health")
async def health():
    return {"status": "healthy"}

# Include router
app.include_router(api_router)

if __name__ == "__main__":
    import uvicorn
    # Configure uvicorn to handle larger request bodies
    uvicorn.run(
        app,
        host="0.0.0.0",
        port=8001,
        limit_concurrency=1000,
        limit_max_requests=1000,
        timeout_keep_alive=30,
    )
