from fastapi import HTTPException, status
from .jwt_token import create_access_token
from .pwd_hashing import HashPwd
from utils.redis_client import redis_client
from uuid import uuid4
import json

class AuthService:
    def __init__(self):
        pass

    async def signup(self, username: str, password: str):
        existing_data = await redis_client.get(f"user:{username}")

        if existing_data:
            return {"message": "Username already exists"}
        user_id = str(uuid4())
        hashed_password = HashPwd.encrypt(password)
        user_data = {
            "id": user_id,
            "username": username,
            "password": hashed_password
        }
        key = f"user:{username}"
        await redis_client.set(key, json.dumps(user_data))
        return {"message": "User created successfully", "user_id": user_id}


    async def get_user(self, username: str):
        key = f"user:{username}"
        data = await redis_client.get(key)
        if data:
            return json.loads(data)
        return {"message": "User not found"}

    async def get_all_users(self):
        keys = await redis_client.keys("user:*")

        if not keys:
            return {"message": "No users found"}

        users = []
        for key in keys:
            user = await redis_client.get(key)
            if user:
                users.append(json.loads(user))

        return users

    async def login(self, username: str, password: str):
        key = f"user:{username}"
        data = await redis_client.get(key)
        if not data:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='User not found')
        user_data = json.loads(data)
        unhashed_password = HashPwd.verifyPwd(user_data["password"], password)
        if not unhashed_password:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Invalid Password')
        
        access_token = create_access_token(data={"sub": user_data["username"]})
        return {"access_token": access_token, "token_type": "bearer"}

    async def delete_user(self, username: str):
        key = f"user:{username}"
        data = await redis_client.get(key)
        if not data:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='User not found')

        await redis_client.delete(key)
        return {"message": "User deleted successfully"}