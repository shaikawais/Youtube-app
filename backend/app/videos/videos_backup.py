import json
import os
from utils.redis_client import redis_client


async def backup_to_file():
    print("📦 Starting backup...")
    os.makedirs("media/backups", exist_ok=True)
    keys = await redis_client.keys("video:*")
    all_videos = []
    for key in keys:
        video = await redis_client.get(key)
        if video:
            all_videos.append(json.loads(video))
    
    backup_path = os.path.join("media/backups", "video_backup.json")
    with open(backup_path, "w") as f:
        json.dump(all_videos, f, indent=4)

    print(f"✅ Backup completed: {backup_path} with {len(all_videos)} videos")