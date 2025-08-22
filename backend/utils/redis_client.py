import os
import redis.asyncio as redis

redis_client = redis.Redis(
    host= os.getenv("REDIS_HOST", "redis_server"),
    port= os.getenv("REDIS_PORT", 6379),
    decode_responses= True
)