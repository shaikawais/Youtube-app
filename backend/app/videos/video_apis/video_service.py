import json
import os
from fastapi.responses import FileResponse, JSONResponse
from utils.redis_client import redis_client
from app.videos.video_data import videos_data
import subprocess
import aiohttp
import aiofiles
from yt_dlp import YoutubeDL

video_dir = "/media/videos"
thumbnail_dir = "/media/thumbnails"


class VideoService:
    def __init__(self):
        pass

    def get_video_duration(self, file_path: str) -> float:
        try:
            result = subprocess.run(
                [
                    "ffprobe",
                    "-v", "error",
                    "-select_streams", "v:0",
                    "-show_entries", "format=duration",
                    "-of", "default=noprint_wrappers=1:nokey=1",
                    file_path
                ],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=True
            )
            duration = float(result.stdout.decode().strip())
            minutes = int(duration // 60)
            seconds = int(duration % 60)
            return f"{minutes:02}:{seconds:02}"
        except Exception as e:
            print(f"[ERROR] Failed to get duration for {file_path}: {e}")
            return "00:00"

    async def get_all_videos(self):
        keys = await redis_client.keys("video:*")
        videos = []

        for key in keys:
            video = await redis_client.get(key)
            if not video:
                return {"message": "Videos not found"}
            video = json.loads(video)
            videos.append({
                "id": video["id"],
                "title": video["title"],
                "thumbnail": video["thumbnail"],
                "duration": video["duration"],
            })
        return videos
    
    async def get_video(self, video_id: str, user_id: str):
        video_key = f"video:{video_id}"
        likes_key = f"likes:{video_id}"
        data = await redis_client.get(video_key)
        if not data:
            return {"message": "Video not found"}
        video = json.loads(data)

        # Check if this user has liked the video
        is_liked = await redis_client.sismember(likes_key, user_id)
        video["is_liked"] = bool(is_liked)

        # Clean up description: keep line breaks but remove leading/trailing spaces on each line
        if "description" in video and isinstance(video["description"], str):
            video["description"] = "\n".join(
                line.strip() for line in video["description"].splitlines()
            ).strip()

        return video
    
    async def load_videos_data(self):
        backup_path = os.path.join("media", "backups", "video_backup.json")

        videos_to_load = []

        if os.path.exists(backup_path):
            with open(backup_path, "r") as f:
                videos_to_load = json.load(f)
                print("Videos loaded from backup file")
        else:
            videos_to_load = videos_data
            print("Videos loaded from static file")

            for video in videos_to_load:
                youtube_url = video.get("youtube_url")
                file_path = os.path.join(video_dir, f"{video['id']}.mp4")
                video["thumbnail"] = await download_youtube_thumbnail(youtube_url, video["id"])
                video["duration"] = self.get_video_duration(file_path)
        async def download_youtube_thumbnail(youtube_url: str, video_id: str) -> str:
            try:
                thumbnail_filename = f"{video_id}.jpg"
                thumbnail_path = os.path.join(thumbnail_dir, thumbnail_filename)

                # ✅ Skip if thumbnail already exists
                if os.path.exists(thumbnail_path):
                    return f"/media/thumbnails/{thumbnail_filename}"

                # 🔍 Extract thumbnail URL from YouTube
                ydl_opts = {
                    'quiet': True,
                    'nocheckcertificate': True,
                    'skip_download': True,
                    'force_generic_extractor': False,
                    'http_headers': {
                        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36'
                    }
                }
                with YoutubeDL(ydl_opts) as ydl:
                    info = ydl.extract_info(youtube_url, download=False)
                    thumbnail_url = info.get("thumbnail")
                    if not thumbnail_url:
                        raise Exception("No thumbnail found")

                # 🌐 Download the thumbnail image
                async with aiohttp.ClientSession() as session:
                    async with session.get(thumbnail_url) as resp:
                        if resp.status != 200:
                            raise Exception("Failed to download thumbnail")
                        content = await resp.read()

                async with aiofiles.open(thumbnail_path, "wb") as f:
                    await f.write(content)

                return f"/media/thumbnails/{thumbnail_filename}"

            except Exception as e:
                print(f"[ERROR] Failed to generate thumbnail for {youtube_url}: {e}")
                return ""
        
        for video in videos_to_load:
            key = f"video:{video['id']}"
            if not await redis_client.exists(key):
                await redis_client.set(key, json.dumps(video))
        return {"message": "Videos loaded successfully"}
    
    async def stream_video(self, video_id: str):
        file_path = os.path.join(video_dir, f"{video_id}.mp4")
        if os.path.exists(file_path):
            return FileResponse(file_path, media_type="video/mp4")
        return JSONResponse({"message": "Video file not found"}, status_code=404)
    
    async def delete_all_videos(self):
        keys = await redis_client.keys("video:*")
        if not keys:
            return {"message": "No videos to delete"}
        
        for key in keys:
            await redis_client.delete(key)
            
        return {"message": "All videos deleted successfully"}