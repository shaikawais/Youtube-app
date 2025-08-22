from fastapi import Depends, FastAPI
from fastapi.concurrency import asynccontextmanager
from fastapi.security import HTTPAuthorizationCredentials
from fastapi.staticfiles import StaticFiles
from app.authentication.auth_resolver import auth_router
from app.authentication.jwt_token import security
from app.videos.video_apis.video_resolver import video_router
from app.videos.interactions.interactions_resolver import interactions_router
from utils.redis_client import redis_client
from app.videos.video_apis.video_service import VideoService
from app.videos.videos_backup import backup_to_file

video_service = VideoService()

@asynccontextmanager
async def lifespan(app: FastAPI):
    pong = await redis_client.ping()
    if pong:
        print("✅ Redis connected")
    else:
        raise Exception("Redis ping failed")

    await video_service.load_videos_data()
    print("✅ Videos loaded")
    yield
    print("🛑 Shutdown running")
    await backup_to_file()
    await redis_client.close()
    print("✅ Backup completed and Redis connection closed")

app = FastAPI(lifespan=lifespan)

app.mount("/media", StaticFiles(directory="media"), name="media")

app.include_router(auth_router)
app.include_router(video_router)
app.include_router(interactions_router)

@app.get('/')
def start():
    return 'FastAPI Started'

@app.get("/protected")
async def protected_route(
    credentials: HTTPAuthorizationCredentials = Depends(security)
):
    token = credentials.credentials
    return {"message": "Access granted", "token": token}
