import json
from utils.redis_client import redis_client
from datetime import datetime


class InteractionsService:
    def __init__(self):
        pass

    async def view_video(self, video_id: str, user_id: str):
        try:
            video_key = f"video:{video_id}"
            likes_key = f"likes:{video_id}"

            # Get the video data
            video_data = await redis_client.get(video_key)

            video = json.loads(video_data)
            video["views"] = video.get("views", 0) + 1

            # Check if this user has liked the video
            is_liked = await redis_client.sismember(likes_key, user_id)
            video["is_liked"] = bool(is_liked)


            # Update the views count in Redis
            await redis_client.set(video_key, json.dumps(video))

            # Clean up description: keep line breaks but remove leading/trailing spaces on each line
            if "description" in video and isinstance(video["description"], str):
                video["description"] = "\n".join(
                    line.strip() for line in video["description"].splitlines()
                ).strip()

            return {"message": "Video viewed", "video": video}
        except Exception as e:
            return {"error": str(e)}
        
    async def like_or_dislike_video(self, video_id: str, user_id: str):
        try:
            likes_key = f"likes:{video_id}"
            video_key = f"video:{video_id}"

            video_data = await redis_client.get(video_key)
            video = json.loads(video_data)

            # Check if user already liked
            already_liked = await redis_client.sismember(likes_key, user_id)
            if not already_liked:
                await redis_client.sadd(likes_key, user_id)
                message = "Video liked"
            else:
                await redis_client.srem(likes_key, user_id)
                message = "Video disliked"

            # Update the count in the video object
            likes_count = await redis_client.scard(likes_key)
            video["likes"] = likes_count
            # Add is_liked inside video
            video["is_liked"] = not already_liked

            # Save updated video back to Redis
            await redis_client.set(video_key, json.dumps(video))

            # Clean up description: keep line breaks but remove leading/trailing spaces on each line
            if "description" in video and isinstance(video["description"], str):
                video["description"] = "\n".join(
                    line.strip() for line in video["description"].splitlines()
                ).strip()
            
            return {"message": message, "video": video}
        except Exception as e:
            return {"error": str(e)}
        
    async def comment_video(self, video_id: str, user_id: str, comment: str):
        try:
            comments_key = f"comments:{video_id}"
            video_key = f"video:{video_id}"

            # Create comment object
            comment_data = {
                "user_id": user_id,
                "comment": comment,
                "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            }

            # Add comment to Redis set
            await redis_client.rpush(comments_key, json.dumps(comment_data))

            # Add comment count to video
            video_data = await redis_client.get(video_key)
            video = json.loads(video_data)
            video["comments"] = video.get("comments", 0) + 1
            await redis_client.set(video_key, json.dumps(video))

            # Get updated comments list
            comments = await redis_client.lrange(comments_key, 0, -1)
            comments = [json.loads(c) for c in comments]

            return {"message": "Comment added", "comments": comments}
        except Exception as e:
            return {"error": str(e)}
        
    async def get_comments(self, video_id: str):
        try:
            comments_key = f"comments:{video_id}"

            # Get comments from Redis
            comments = await redis_client.lrange(comments_key, 0, -1)
            comments = [json.loads(c) for c in comments]

            return {"comments": comments}
        except Exception as e:
            return {"error": str(e)}