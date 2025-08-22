from fastapi import APIRouter
from app.videos.interactions.interactions_service import InteractionsService

interactions_router = APIRouter(
    prefix="/interactions",
    tags=["interactions"],
    responses={404: {"description": "Not found"}},
)

interactions_service = InteractionsService()

@interactions_router.patch('/view_video')
async def view_video(video_id: str):
    return await interactions_service.view_video(video_id)

@interactions_router.patch('/like_video')
async def like_or_dislike_video(video_id: str, user_id: str):
    return await interactions_service.like_or_dislike_video(video_id, user_id)

@interactions_router.patch('/comment_video')
async def comment_video(video_id: str, user_id: str, comment: str):
    return await interactions_service.comment_video(video_id, user_id, comment)

@interactions_router.get('/get_comments')
async def get_comments(video_id: str):
    return await interactions_service.get_comments(video_id)