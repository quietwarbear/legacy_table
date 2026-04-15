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
import jwt as pyjwt
import bcrypt
import json
import httpx
import base64
from openai import AsyncOpenAI
from cryptography.hazmat.primitives.asymmetric.rsa import RSAPublicNumbers
from cryptography.hazmat.backends import default_backend

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

# ===================== OPENAI CLIENT =====================
OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY", "")
openai_client = AsyncOpenAI(api_key=OPENAI_API_KEY) if OPENAI_API_KEY else None

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

class AppleAuthRequest(BaseModel):
    id_token: str
    full_name: Optional[str] = ""
    email: Optional[str] = ""

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
    holiday_tags: List[str] = []

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
    google_ios_client_id = os.environ.get("GOOGLE_IOS_CLIENT_ID")
    allowed_google_client_ids = {
        client_id
        for client_id in [google_client_id, google_ios_client_id]
        if client_id
    }

    # Legacy Table native iOS client ID fallback so mobile sign-in can work
    # even if the optional env var has not been added in Railway yet.
    allowed_google_client_ids.add(
        "229052236659-h4op49fi71nktbtrtp0vjdemaaputub7.apps.googleusercontent.com"
    )

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
    if google_info.get("aud") not in allowed_google_client_ids:
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

# Apple Auth JWKS Cache
_apple_jwks_cache = None
_apple_jwks_cache_time = None

async def get_apple_public_keys():
    """Fetch and cache Apple's public keys from https://appleid.apple.com/auth/keys"""
    global _apple_jwks_cache, _apple_jwks_cache_time

    # Cache for 1 hour
    now = datetime.now(timezone.utc)
    if _apple_jwks_cache and _apple_jwks_cache_time:
        if (now - _apple_jwks_cache_time).total_seconds() < 3600:
            return _apple_jwks_cache

    async with httpx.AsyncClient() as http_client:
        resp = await http_client.get("https://appleid.apple.com/auth/keys")
        if resp.status_code != 200:
            raise HTTPException(status_code=500, detail="Could not fetch Apple public keys")

    keys_data = resp.json()
    _apple_jwks_cache = keys_data["keys"]
    _apple_jwks_cache_time = now
    return _apple_jwks_cache

def get_apple_public_key(kid: str):
    """Get a specific public key by kid from the cached keys"""
    for key_data in _apple_jwks_cache or []:
        if key_data.get("kid") == kid:
            return key_data
    return None

async def verify_apple_token(id_token: str):
    """Verify an Apple identity token and return the claims"""
    try:
        # Get the header without verification to extract the kid
        unverified_header = pyjwt.get_unverified_header(id_token)
        kid = unverified_header.get("kid")
        if not kid:
            raise HTTPException(status_code=401, detail="Invalid Apple token header")

        # Fetch Apple's public keys
        apple_keys = await get_apple_public_keys()

        # Find the key with matching kid
        key_data = None
        for k in apple_keys:
            if k.get("kid") == kid:
                key_data = k
                break

        if not key_data:
            raise HTTPException(status_code=401, detail="Apple token kid not found")

        # Reconstruct the public key from JWK
        n = int.from_bytes(base64.urlsafe_b64decode(key_data["n"] + "=="), byteorder="big")
        e = int.from_bytes(base64.urlsafe_b64decode(key_data["e"] + "=="), byteorder="big")
        public_numbers = RSAPublicNumbers(e, n)
        public_key = public_numbers.public_key(default_backend())

        # Verify the token — accept both native Bundle ID and web Services ID
        valid_audiences = [
            a for a in [
                os.environ.get("APPLE_BUNDLE_ID"),
                os.environ.get("APPLE_SERVICE_ID"),
            ] if a
        ]
        claims = pyjwt.decode(
            id_token,
            public_key,
            algorithms=["RS256"],
            audience=valid_audiences or None,
            issuer="https://appleid.apple.com",
        )

        return claims
    except pyjwt.DecodeError as e:
        raise HTTPException(status_code=401, detail=f"Invalid Apple token: {str(e)}")
    except Exception as e:
        raise HTTPException(status_code=401, detail=f"Token verification failed: {str(e)}")

@api_router.post("/auth/apple", response_model=TokenResponse)
async def apple_auth(body: AppleAuthRequest):
    """Verify Apple ID token and login or register the user."""
    # Verify the Apple identity token
    claims = await verify_apple_token(body.id_token)

    email = claims.get("email", body.email or "").lower()
    if not email:
        raise HTTPException(status_code=400, detail="Email not provided by Apple")

    # Use provided full_name or extract from claims sub
    full_name = body.full_name or claims.get("sub", "")

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
        # New user — register with Apple info (no password)
        user_id = str(uuid.uuid4())
        initial_credits = get_credits_for_tier(None)
        credits_refresh = next_refresh_date()
        user_doc = {
            "id": user_id,
            "name": full_name or email.split("@")[0],
            "nickname": None,
            "email": email,
            "password_hash": None,  # Apple users have no password
            "avatar": None,  # Apple does not provide picture
            "auth_provider": "apple",
            "credits_balance": initial_credits,
            "credits_refresh_at": credits_refresh,
            "created_at": datetime.now(timezone.utc).isoformat()
        }
        await db.users.insert_one(user_doc)
        token = create_token(user_id)
        user_response = UserResponse(
            id=user_id,
            name=user_doc["name"],
            nickname=None,
            email=email,
            avatar=None,
            family_id=None,
            role=None,
            subscription_tier=None,
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


# ---- Backup & Export ----

@api_router.get("/export/recipes")
async def export_recipes(user: dict = Depends(get_current_user)):
    """
    Export all of the user's family recipes as a JSON backup.
    Includes recipe data, comments count, and family info.
    Strips base64 photo data to keep the export manageable.
    """
    family_id = user.get("family_id")
    if not family_id:
        raise HTTPException(status_code=400, detail="You need to be in a family to export recipes")

    family = await db.families.find_one({"id": family_id}, {"_id": 0})
    recipes_cursor = db.recipes.find({"family_id": family_id}, {"_id": 0})
    recipes = await recipes_cursor.to_list(length=1000)

    # Strip heavy base64 photo data, keep count
    for r in recipes:
        photo_count = len(r.get("photos", []))
        r["photo_count"] = photo_count
        r["photos"] = []  # Clear base64 data from export

    export_data = {
        "exported_at": datetime.now(timezone.utc).isoformat(),
        "exported_by": {
            "id": user["id"],
            "name": user.get("name"),
            "email": user.get("email"),
        },
        "family": {
            "id": family_id,
            "name": family.get("name") if family else None,
        },
        "recipe_count": len(recipes),
        "recipes": recipes,
        "app_version": "1.0.4",
        "format_version": "1.0",
    }

    logger.info("Exported %d recipes for user=%s family=%s", len(recipes), user["id"], family_id)
    return export_data


# ---- Founder Badge ----

# Users who signed up before this date get a Founder badge
FOUNDER_CUTOFF = "2026-06-01T00:00:00+00:00"


@api_router.get("/badges")
async def get_badges(user: dict = Depends(get_current_user)):
    """Return badges the user has earned."""
    badges = []

    # Founder badge — signed up before cutoff
    created_at = user.get("created_at", "")
    try:
        if created_at and created_at < FOUNDER_CUTOFF:
            badges.append({
                "id": "founder",
                "name": "Founding Family",
                "description": "Joined Legacy Table in its earliest days",
                "icon": "flame",
                "color": "#D97706",
            })
    except (TypeError, ValueError):
        pass

    # Recipe milestones
    family_id = user.get("family_id")
    if family_id:
        recipe_count = await db.recipes.count_documents({"family_id": family_id, "author_id": user["id"]})
        if recipe_count >= 1:
            badges.append({
                "id": "first_recipe",
                "name": "First Dish",
                "description": "Added your first family recipe",
                "icon": "chef-hat",
                "color": "#059669",
            })
        if recipe_count >= 10:
            badges.append({
                "id": "recipe_collector",
                "name": "Recipe Collector",
                "description": "Added 10 family recipes",
                "icon": "book-open",
                "color": "#7C3AED",
            })
        if recipe_count >= 50:
            badges.append({
                "id": "legacy_keeper",
                "name": "Legacy Keeper",
                "description": "Added 50 family recipes",
                "icon": "crown",
                "color": "#DC2626",
            })

    # Family keeper badge
    if user.get("role") == "keeper":
        badges.append({
            "id": "family_keeper",
            "name": "Family Keeper",
            "description": "You manage your family's recipe collection",
            "icon": "users",
            "color": "#2563EB",
        })

    return {"badges": badges}


# ===================== AI RECIPE SCANNER (Milestone 2.1) =====================

RECIPE_SCAN_PROMPT = """You are a recipe extraction assistant for a family recipe app called Legacy Table.
Analyze this image of a recipe (handwritten, printed, or from a book/card) and extract the following structured data.

Return ONLY valid JSON with these exact keys:
{
  "title": "Recipe title",
  "ingredients": ["ingredient 1 with quantity", "ingredient 2 with quantity", ...],
  "instructions": "Full cooking instructions as a single string with paragraph breaks",
  "cooking_time": 30,
  "servings": 4,
  "category": "Main Course",
  "difficulty": "easy",
  "story": "Any personal notes, history, or story visible on the recipe card (or null if none)"
}

Rules:
- cooking_time is in minutes (integer). Estimate if not stated.
- servings is an integer. Estimate if not stated (default 4).
- category must be one of: Main Course, Appetizer, Dessert, Soup, Salad, Breakfast, Snack, Beverage
- difficulty must be one of: easy, medium, hard (estimate based on complexity)
- Keep ingredients as a clean list with quantities
- Instructions should be clear, readable paragraphs
- If you see a story, family note, or dedication on the card, capture it in "story"
- Return ONLY the JSON object, no markdown, no explanation"""


@api_router.post("/ai/scan-recipe")
async def scan_recipe(request: Request, credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Scan a photo of a recipe and extract structured data using GPT-4 Vision."""
    if not openai_client:
        raise HTTPException(status_code=503, detail="AI features are not configured")

    user = await get_current_user(credentials)

    # Consume credit
    user = await consume_credit(user, "recipe_scan")

    body = await request.json()
    image_data = body.get("image")  # Base64 data URL
    if not image_data:
        raise HTTPException(status_code=400, detail="No image provided")

    # Handle data URL format: strip prefix if present
    if image_data.startswith("data:"):
        # e.g., data:image/jpeg;base64,/9j/4AAQ...
        image_data_b64 = image_data.split(",", 1)[1] if "," in image_data else image_data
        media_type = image_data.split(";")[0].split(":")[1] if ";" in image_data else "image/jpeg"
    else:
        image_data_b64 = image_data
        media_type = "image/jpeg"

    try:
        response = await openai_client.chat.completions.create(
            model="gpt-4o",
            messages=[
                {
                    "role": "user",
                    "content": [
                        {"type": "text", "text": RECIPE_SCAN_PROMPT},
                        {
                            "type": "image_url",
                            "image_url": {
                                "url": f"data:{media_type};base64,{image_data_b64}",
                                "detail": "high",
                            },
                        },
                    ],
                }
            ],
            max_tokens=2000,
            temperature=0.1,
        )

        result_text = response.choices[0].message.content.strip()

        # Parse JSON — strip markdown fences if present
        if result_text.startswith("```"):
            result_text = result_text.split("\n", 1)[1] if "\n" in result_text else result_text[3:]
            if result_text.endswith("```"):
                result_text = result_text[:-3]
            result_text = result_text.strip()

        recipe_data = json.loads(result_text)

        # Validate required fields
        required = ["title", "ingredients", "instructions"]
        for field in required:
            if field not in recipe_data or not recipe_data[field]:
                raise ValueError(f"Missing required field: {field}")

        # Set defaults for optional fields
        recipe_data.setdefault("cooking_time", 30)
        recipe_data.setdefault("servings", 4)
        recipe_data.setdefault("category", "Main Course")
        recipe_data.setdefault("difficulty", "easy")
        recipe_data.setdefault("story", None)

        return {
            "success": True,
            "recipe": recipe_data,
            "credits_remaining": user.get("credits_balance", 0),
        }

    except json.JSONDecodeError as e:
        logger.error("AI recipe scan JSON parse error: %s", e)
        raise HTTPException(status_code=422, detail="AI could not parse this image into a recipe. Try a clearer photo.")
    except Exception as e:
        logger.error("AI recipe scan error: %s", e)
        raise HTTPException(status_code=500, detail=f"AI processing failed: {str(e)}")


# ===================== VOICE-TO-RECIPE (Milestone 2.2) =====================

VOICE_RECIPE_PROMPT = """You are a recipe structuring assistant for a family recipe app called Legacy Table.
The user dictated a recipe by voice. The transcription is below. Extract and structure it into a clean recipe.

Return ONLY valid JSON with these exact keys:
{
  "title": "Recipe title (infer from context if not stated)",
  "ingredients": ["ingredient 1 with quantity", "ingredient 2 with quantity", ...],
  "instructions": "Full cooking instructions as a single string with paragraph breaks",
  "cooking_time": 30,
  "servings": 4,
  "category": "Main Course",
  "difficulty": "easy",
  "story": "Any personal story or context the speaker mentioned (or null)"
}

Rules:
- Clean up filler words (um, uh, like, you know) from instructions
- Organize rambling narration into clear step-by-step instructions
- Extract ingredient quantities even if stated informally ("about two cups of flour" → "2 cups flour")
- cooking_time in minutes, servings as integer
- category: Main Course, Appetizer, Dessert, Soup, Salad, Breakfast, Snack, or Beverage
- difficulty: easy, medium, or hard
- If the speaker shares personal stories or memories, capture them in "story"
- Return ONLY the JSON object"""


@api_router.post("/ai/voice-to-recipe")
async def voice_to_recipe(request: Request, credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Transcribe audio of a spoken recipe and extract structured data."""
    if not openai_client:
        raise HTTPException(status_code=503, detail="AI features are not configured")

    user = await get_current_user(credentials)

    # Consume credit (voice costs 2)
    user = await consume_credit(user, "voice_to_recipe")

    body = await request.json()
    audio_data = body.get("audio")  # Base64 encoded audio
    audio_format = body.get("format", "webm")  # webm, mp4, wav, etc.

    if not audio_data:
        raise HTTPException(status_code=400, detail="No audio provided")

    # Strip data URL prefix if present
    if audio_data.startswith("data:"):
        audio_data = audio_data.split(",", 1)[1] if "," in audio_data else audio_data

    try:
        # Step 1: Transcribe with Whisper
        import tempfile
        audio_bytes = base64.b64decode(audio_data)

        with tempfile.NamedTemporaryFile(suffix=f".{audio_format}", delete=True) as tmp:
            tmp.write(audio_bytes)
            tmp.flush()

            with open(tmp.name, "rb") as audio_file:
                transcript = await openai_client.audio.transcriptions.create(
                    model="whisper-1",
                    file=audio_file,
                    language="en",
                )

        transcription_text = transcript.text
        if not transcription_text or len(transcription_text.strip()) < 10:
            raise HTTPException(status_code=422, detail="Could not transcribe audio. Please speak clearly and try again.")

        # Step 2: Structure with GPT-4o
        response = await openai_client.chat.completions.create(
            model="gpt-4o",
            messages=[
                {"role": "system", "content": VOICE_RECIPE_PROMPT},
                {"role": "user", "content": f"Here is the transcription of a spoken recipe:\n\n{transcription_text}"},
            ],
            max_tokens=2000,
            temperature=0.1,
        )

        result_text = response.choices[0].message.content.strip()

        # Parse JSON
        if result_text.startswith("```"):
            result_text = result_text.split("\n", 1)[1] if "\n" in result_text else result_text[3:]
            if result_text.endswith("```"):
                result_text = result_text[:-3]
            result_text = result_text.strip()

        recipe_data = json.loads(result_text)

        # Validate
        required = ["title", "ingredients", "instructions"]
        for field in required:
            if field not in recipe_data or not recipe_data[field]:
                raise ValueError(f"Missing required field: {field}")

        recipe_data.setdefault("cooking_time", 30)
        recipe_data.setdefault("servings", 4)
        recipe_data.setdefault("category", "Main Course")
        recipe_data.setdefault("difficulty", "easy")
        recipe_data.setdefault("story", None)

        return {
            "success": True,
            "transcription": transcription_text,
            "recipe": recipe_data,
            "credits_remaining": user.get("credits_balance", 0),
        }

    except json.JSONDecodeError as e:
        logger.error("Voice recipe JSON parse error: %s", e)
        raise HTTPException(status_code=422, detail="AI could not structure the transcription into a recipe. Try speaking more clearly.")
    except HTTPException:
        raise
    except Exception as e:
        logger.error("Voice-to-recipe error: %s", e)
        raise HTTPException(status_code=500, detail=f"AI processing failed: {str(e)}")


# ===================== SAVE FROM SOCIAL MEDIA (Milestone 3.2) =====================

SOCIAL_RECIPE_PROMPT = """You are a recipe extraction assistant for Legacy Table, a family recipe app.
The user pasted a link to a cooking video or post from social media. Below is the metadata we extracted from the page (title, description, author, thumbnail).

Using this metadata, create a structured recipe. If the description doesn't contain a full recipe, do your best to infer reasonable ingredients and instructions from the title and description.

Return ONLY valid JSON:
{
  "title": "Recipe title",
  "ingredients": ["ingredient 1", "ingredient 2", ...],
  "instructions": "Step-by-step instructions",
  "cooking_time": 30,
  "servings": 4,
  "category": "Main Course",
  "difficulty": "easy",
  "story": "Saved from @username on TikTok/Instagram",
  "source_url": "original URL",
  "source_author": "creator name"
}

Rules:
- category: Main Course, Appetizer, Dessert, Soup, Salad, Breakfast, Snack, or Beverage
- difficulty: easy, medium, or hard
- If you can't determine full ingredients/instructions from the metadata, provide your best educated guess based on the recipe title and mark instructions with "(Adapted from video — adjust to taste)"
- Return ONLY JSON"""


@api_router.post("/ai/save-from-link")
async def save_from_link(request: Request, credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Extract recipe from a TikTok/Instagram/YouTube link using oEmbed + AI."""
    if not openai_client:
        raise HTTPException(status_code=503, detail="AI features are not configured")

    user = await get_current_user(credentials)
    user = await consume_credit(user, "recipe_scan")  # 1 credit

    body = await request.json()
    url = body.get("url", "").strip()
    if not url:
        raise HTTPException(status_code=400, detail="No URL provided")

    # Determine platform and fetch oEmbed metadata
    metadata = {"url": url, "title": "", "description": "", "author": "", "thumbnail": ""}

    try:
        async with httpx.AsyncClient(timeout=15) as client:
            # Try oEmbed endpoints
            oembed_url = None
            if "tiktok.com" in url:
                oembed_url = f"https://www.tiktok.com/oembed?url={url}"
            elif "instagram.com" in url:
                oembed_url = f"https://api.instagram.com/oembed?url={url}"
            elif "youtube.com" in url or "youtu.be" in url:
                oembed_url = f"https://www.youtube.com/oembed?url={url}&format=json"

            if oembed_url:
                resp = await client.get(oembed_url)
                if resp.status_code == 200:
                    data = resp.json()
                    metadata["title"] = data.get("title", "")
                    metadata["author"] = data.get("author_name", "")
                    metadata["thumbnail"] = data.get("thumbnail_url", "")
                    metadata["description"] = data.get("title", "")  # oEmbed often puts description in title

            # Fallback: try to get Open Graph tags via a HEAD-like request
            if not metadata["title"]:
                resp = await client.get(url, follow_redirects=True, headers={"User-Agent": "Mozilla/5.0"})
                text = resp.text[:5000]  # Only scan first 5k chars
                import re
                og_title = re.search(r'<meta[^>]+property=["\']og:title["\'][^>]+content=["\']([^"\']+)', text)
                og_desc = re.search(r'<meta[^>]+property=["\']og:description["\'][^>]+content=["\']([^"\']+)', text)
                og_image = re.search(r'<meta[^>]+property=["\']og:image["\'][^>]+content=["\']([^"\']+)', text)
                if og_title:
                    metadata["title"] = og_title.group(1)
                if og_desc:
                    metadata["description"] = og_desc.group(1)
                if og_image:
                    metadata["thumbnail"] = og_image.group(1)

    except Exception as e:
        logger.warning("Failed to fetch social media metadata: %s", e)
        # Continue with whatever we have — AI can work with just the URL

    # Use GPT-4o to structure into a recipe
    try:
        meta_text = f"URL: {url}\nTitle: {metadata['title']}\nAuthor: {metadata['author']}\nDescription: {metadata['description']}"

        response = await openai_client.chat.completions.create(
            model="gpt-4o",
            messages=[
                {"role": "system", "content": SOCIAL_RECIPE_PROMPT},
                {"role": "user", "content": meta_text},
            ],
            max_tokens=2000,
            temperature=0.2,
        )

        result_text = response.choices[0].message.content.strip()
        if result_text.startswith("```"):
            result_text = result_text.split("\n", 1)[1] if "\n" in result_text else result_text[3:]
            if result_text.endswith("```"):
                result_text = result_text[:-3]
            result_text = result_text.strip()

        recipe_data = json.loads(result_text)
        recipe_data.setdefault("cooking_time", 30)
        recipe_data.setdefault("servings", 4)
        recipe_data.setdefault("category", "Main Course")
        recipe_data.setdefault("difficulty", "easy")
        recipe_data["source_url"] = url
        recipe_data["source_author"] = metadata.get("author", "")

        return {
            "success": True,
            "recipe": recipe_data,
            "metadata": metadata,
            "credits_remaining": user.get("credits_balance", 0),
        }

    except json.JSONDecodeError:
        raise HTTPException(status_code=422, detail="Could not extract a recipe from this link. Try a different video.")
    except Exception as e:
        logger.error("Save from link error: %s", e)
        raise HTTPException(status_code=500, detail=f"Failed to process link: {str(e)}")


# ===================== LEGACY CLIPS (Milestone 3.3) =====================

@api_router.post("/recipes/{recipe_id}/clips")
async def add_legacy_clip(recipe_id: str, request: Request, credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Add a short video clip (legacy clip) to a recipe. Max 16MB base64."""
    user = await get_current_user(credentials)

    recipe = await db.recipes.find_one({"_id": recipe_id})
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    if recipe.get("family_id") != user.get("family_id"):
        raise HTTPException(status_code=403, detail="You can only add clips to family recipes")

    body = await request.json()
    video_data = body.get("video")  # Base64 data URL
    caption = body.get("caption", "")
    duration = body.get("duration", 0)  # seconds

    if not video_data:
        raise HTTPException(status_code=400, detail="No video provided")

    # Check size (rough estimate: base64 is ~33% larger than binary)
    data_part = video_data.split(",", 1)[1] if "," in video_data else video_data
    estimated_size_mb = len(data_part) * 3 / 4 / (1024 * 1024)
    if estimated_size_mb > 16:
        raise HTTPException(status_code=413, detail="Video too large. Please record clips under 30 seconds.")

    clip = {
        "id": str(uuid.uuid4()),
        "video": video_data,
        "caption": caption[:200],
        "duration": min(duration, 60),
        "author_id": user["id"],
        "author_name": user.get("name", "Unknown"),
        "created_at": datetime.now(timezone.utc).isoformat(),
    }

    await db.recipes.update_one(
        {"_id": recipe_id},
        {"$push": {"legacy_clips": clip}}
    )

    return {"success": True, "clip": {k: v for k, v in clip.items() if k != "video"}}


@api_router.get("/recipes/{recipe_id}/clips")
async def get_legacy_clips(recipe_id: str, credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Get all legacy clips for a recipe (metadata only, no video data)."""
    user = await get_current_user(credentials)

    recipe = await db.recipes.find_one({"_id": recipe_id})
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")

    clips = recipe.get("legacy_clips", [])
    # Return metadata without the heavy video data
    clips_meta = [{k: v for k, v in c.items() if k != "video"} for c in clips]
    return {"clips": clips_meta}


@api_router.get("/recipes/{recipe_id}/clips/{clip_id}")
async def get_legacy_clip_video(recipe_id: str, clip_id: str, credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Get a single legacy clip with video data for playback."""
    user = await get_current_user(credentials)

    recipe = await db.recipes.find_one({"_id": recipe_id})
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")

    clips = recipe.get("legacy_clips", [])
    clip = next((c for c in clips if c["id"] == clip_id), None)
    if not clip:
        raise HTTPException(status_code=404, detail="Clip not found")

    return {"clip": clip}


@api_router.delete("/recipes/{recipe_id}/clips/{clip_id}")
async def delete_legacy_clip(recipe_id: str, clip_id: str, credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Delete a legacy clip from a recipe."""
    user = await get_current_user(credentials)

    recipe = await db.recipes.find_one({"_id": recipe_id})
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")

    # Must be clip author or family keeper
    clips = recipe.get("legacy_clips", [])
    clip = next((c for c in clips if c["id"] == clip_id), None)
    if not clip:
        raise HTTPException(status_code=404, detail="Clip not found")

    if clip["author_id"] != user["id"] and user.get("role") != "keeper":
        raise HTTPException(status_code=403, detail="You can only delete your own clips")

    await db.recipes.update_one(
        {"_id": recipe_id},
        {"$pull": {"legacy_clips": {"id": clip_id}}}
    )

    return {"success": True}


# ===================== HOLIDAY HEADQUARTERS =====================

# Comprehensive food-centric holiday calendar
# Each holiday has: name, date (MM-DD), season, emoji, description, suggested categories
HOLIDAY_CALENDAR = [
    # January
    {"name": "New Year's Day", "month": 1, "day": 1, "season": "winter", "emoji": "🎆", "description": "Ring in the new year with family favorites", "suggested_categories": ["Appetizers", "Desserts", "Drinks"]},
    {"name": "MLK Day", "month": 1, "day": 20, "season": "winter", "emoji": "✊🏿", "description": "Honor the legacy with soul food traditions", "suggested_categories": ["Soul Food", "Main Dishes", "Sides"]},
    # February
    {"name": "Super Bowl Sunday", "month": 2, "day": 9, "season": "winter", "emoji": "🏈", "description": "Game day spreads and finger foods", "suggested_categories": ["Appetizers", "Snacks", "Dips"]},
    {"name": "Valentine's Day", "month": 2, "day": 14, "season": "winter", "emoji": "❤️", "description": "Cook something special for someone you love", "suggested_categories": ["Desserts", "Main Dishes", "Drinks"]},
    {"name": "Black History Month", "month": 2, "day": 1, "season": "winter", "emoji": "✊🏿", "description": "Celebrate heritage recipes all month long", "suggested_categories": ["Soul Food", "Heritage", "Main Dishes"]},
    # March
    {"name": "St. Patrick's Day", "month": 3, "day": 17, "season": "spring", "emoji": "☘️", "description": "Lucky dishes and green-themed recipes", "suggested_categories": ["Main Dishes", "Soups", "Desserts"]},
    # April
    {"name": "Easter", "month": 4, "day": 5, "season": "spring", "emoji": "🐣", "description": "Easter brunch and spring celebration dishes", "suggested_categories": ["Brunch", "Desserts", "Main Dishes"]},
    {"name": "Passover", "month": 4, "day": 12, "season": "spring", "emoji": "🕎", "description": "Traditional Seder dishes and matzo recipes", "suggested_categories": ["Main Dishes", "Sides", "Desserts"]},
    # May
    {"name": "Cinco de Mayo", "month": 5, "day": 5, "season": "spring", "emoji": "🇲🇽", "description": "Mexican-inspired family favorites", "suggested_categories": ["Main Dishes", "Appetizers", "Drinks"]},
    {"name": "Mother's Day", "month": 5, "day": 11, "season": "spring", "emoji": "💐", "description": "Make Mom's favorite dish — or the one she always made for you", "suggested_categories": ["Brunch", "Desserts", "Main Dishes"]},
    {"name": "Memorial Day", "month": 5, "day": 26, "season": "spring", "emoji": "🇺🇸", "description": "Kick off cookout season with the family", "suggested_categories": ["Grilling", "Sides", "Desserts"]},
    # June
    {"name": "Juneteenth", "month": 6, "day": 19, "season": "summer", "emoji": "✊🏿", "description": "Freedom celebration with red foods and heritage dishes", "suggested_categories": ["Soul Food", "Grilling", "Desserts"]},
    {"name": "Father's Day", "month": 6, "day": 15, "season": "summer", "emoji": "👔", "description": "Dad's grill secrets and his favorite dishes", "suggested_categories": ["Grilling", "Main Dishes", "Desserts"]},
    # July
    {"name": "4th of July", "month": 7, "day": 4, "season": "summer", "emoji": "🎇", "description": "Cookouts, fireworks, and family recipes", "suggested_categories": ["Grilling", "Sides", "Desserts"]},
    # August
    {"name": "Back to School", "month": 8, "day": 15, "season": "summer", "emoji": "📚", "description": "Easy weeknight meals for busy families", "suggested_categories": ["Quick Meals", "Lunch", "Snacks"]},
    # September
    {"name": "Labor Day", "month": 9, "day": 1, "season": "fall", "emoji": "🍔", "description": "Last cookout of summer", "suggested_categories": ["Grilling", "Sides", "Desserts"]},
    # October
    {"name": "Halloween", "month": 10, "day": 31, "season": "fall", "emoji": "🎃", "description": "Spooky treats and festive party food", "suggested_categories": ["Desserts", "Snacks", "Appetizers"]},
    # November
    {"name": "Thanksgiving", "month": 11, "day": 27, "season": "fall", "emoji": "🦃", "description": "The biggest food holiday — every family recipe matters", "suggested_categories": ["Main Dishes", "Sides", "Desserts"]},
    # December
    {"name": "Hanukkah", "month": 12, "day": 14, "season": "winter", "emoji": "🕎", "description": "Latkes, brisket, and family traditions", "suggested_categories": ["Main Dishes", "Sides", "Desserts"]},
    {"name": "Christmas", "month": 12, "day": 25, "season": "winter", "emoji": "🎄", "description": "Christmas dinner and holiday baking", "suggested_categories": ["Main Dishes", "Desserts", "Baking"]},
    {"name": "Kwanzaa", "month": 12, "day": 26, "season": "winter", "emoji": "🕯️", "description": "Seven days of heritage cooking and community", "suggested_categories": ["Soul Food", "Heritage", "Main Dishes"]},
    {"name": "New Year's Eve", "month": 12, "day": 31, "season": "winter", "emoji": "🥂", "description": "End the year with your best dishes", "suggested_categories": ["Appetizers", "Main Dishes", "Drinks"]},
]

SEASON_THEMES = {
    "spring": {"color": "#059669", "gradient": ["#D1FAE5", "#A7F3D0"], "label": "Spring Cooking"},
    "summer": {"color": "#D97706", "gradient": ["#FEF3C7", "#FDE68A"], "label": "Summer Grilling"},
    "fall": {"color": "#DC2626", "gradient": ["#FEE2E2", "#FECACA"], "label": "Fall Harvest"},
    "winter": {"color": "#7C3AED", "gradient": ["#EDE9FE", "#DDD6FE"], "label": "Winter Warmth"},
}


def get_current_season() -> str:
    """Return current season based on month."""
    month = datetime.now(timezone.utc).month
    if month in (3, 4, 5):
        return "spring"
    elif month in (6, 7, 8):
        return "summer"
    elif month in (9, 10, 11):
        return "fall"
    else:
        return "winter"


def get_upcoming_holidays(count: int = 5) -> list:
    """Return the next N upcoming holidays from today."""
    now = datetime.now(timezone.utc)
    current_month = now.month
    current_day = now.day

    # Sort holidays by how soon they come after today
    scored = []
    for h in HOLIDAY_CALENDAR:
        m, d = h["month"], h["day"]
        # Days until this holiday (wrapping around year)
        if (m, d) >= (current_month, current_day):
            days_away = (datetime(now.year, m, d) - datetime(now.year, current_month, current_day)).days
        else:
            days_away = (datetime(now.year + 1, m, d) - datetime(now.year, current_month, current_day)).days
        scored.append({**h, "days_away": days_away})

    scored.sort(key=lambda x: x["days_away"])
    return scored[:count]


@api_router.get("/holidays")
async def get_holidays(credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Get upcoming holidays and current season info for Celebration Headquarters."""
    user = await get_current_user(credentials)

    upcoming = get_upcoming_holidays(6)
    season = get_current_season()
    theme = SEASON_THEMES[season]

    # Get user's holiday-tagged recipes count
    family_id = user.get("family_id")
    holiday_recipe_counts = {}
    if family_id:
        pipeline = [
            {"$match": {"family_id": family_id, "holiday_tags": {"$exists": True, "$ne": []}}},
            {"$unwind": "$holiday_tags"},
            {"$group": {"_id": "$holiday_tags", "count": {"$sum": 1}}},
        ]
        async for doc in db.recipes.aggregate(pipeline):
            holiday_recipe_counts[doc["_id"]] = doc["count"]

    return {
        "upcoming": upcoming,
        "season": season,
        "season_theme": theme,
        "holiday_recipe_counts": holiday_recipe_counts,
        "all_holidays": HOLIDAY_CALENDAR,
    }


@api_router.get("/holidays/{holiday_name}/recipes")
async def get_holiday_recipes(holiday_name: str, credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Get all recipes tagged with a specific holiday."""
    user = await get_current_user(credentials)
    family_id = user.get("family_id")
    if not family_id:
        raise HTTPException(status_code=400, detail="Join a family first to see holiday recipes")

    recipes = []
    cursor = db.recipes.find({"family_id": family_id, "holiday_tags": holiday_name})
    async for recipe in cursor:
        recipe["id"] = recipe.pop("_id")
        recipes.append(RecipeResponse(**recipe).model_dump())

    return {"holiday": holiday_name, "recipes": recipes}


@api_router.post("/recipes/{recipe_id}/holiday-tags")
async def update_holiday_tags(recipe_id: str, request: Request, credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Add or replace holiday tags on a recipe."""
    user = await get_current_user(credentials)
    body = await request.json()
    tags = body.get("tags", [])

    # Validate tags are real holiday names
    valid_names = {h["name"] for h in HOLIDAY_CALENDAR}
    invalid = [t for t in tags if t not in valid_names]
    if invalid:
        raise HTTPException(status_code=400, detail=f"Invalid holiday names: {invalid}")

    recipe = await db.recipes.find_one({"_id": recipe_id})
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")

    # Must be in same family
    if recipe.get("family_id") != user.get("family_id"):
        raise HTTPException(status_code=403, detail="You can only tag recipes in your family")

    await db.recipes.update_one(
        {"_id": recipe_id},
        {"$set": {"holiday_tags": tags}}
    )

    return {"recipe_id": recipe_id, "holiday_tags": tags}


@api_router.get("/holidays/season/{season_name}")
async def get_season_recipes(season_name: str, credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Get recipes tagged with holidays in a specific season."""
    if season_name not in SEASON_THEMES:
        raise HTTPException(status_code=400, detail=f"Invalid season. Use: {list(SEASON_THEMES.keys())}")

    user = await get_current_user(credentials)
    family_id = user.get("family_id")
    if not family_id:
        raise HTTPException(status_code=400, detail="Join a family first")

    # Get holiday names for this season
    season_holidays = [h["name"] for h in HOLIDAY_CALENDAR if h["season"] == season_name]

    recipes = []
    cursor = db.recipes.find({
        "family_id": family_id,
        "holiday_tags": {"$in": season_holidays}
    })
    async for recipe in cursor:
        recipe["id"] = recipe.pop("_id")
        recipes.append(RecipeResponse(**recipe).model_dump())

    return {
        "season": season_name,
        "theme": SEASON_THEMES[season_name],
        "holidays": season_holidays,
        "recipes": recipes,
    }


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
