from fastapi import APIRouter
from app.videos.video_apis.video_service import VideoService

video_router = APIRouter(
    prefix="/videos",
    tags=["videos"],
    responses={404: {"description": "Not found"}},
)

video_service = VideoService()

@video_router.get("/all_videos")
async def get_all_videos():
    return await video_service.get_all_videos()

@video_router.get("/video")
async def get_video(video_id: str, user_id: str):
    return await video_service.get_video(video_id, user_id)

@video_router.get("/stream/{video_id}")
async def stream_video(video_id: str):
    return await video_service.stream_video(video_id)

@video_router.post("/load_videos")
async def load_videos():
    return await video_service.load_videos_data()

@video_router.delete("/delete_all_videos")
async def delete_all_videos():
    return await video_service.delete_all_videos()