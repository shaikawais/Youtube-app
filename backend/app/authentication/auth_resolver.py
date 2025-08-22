from fastapi import APIRouter, Depends

from .jwt_token import get_current_user
from models.user import User
from .auth_service import AuthService

auth_router = APIRouter(
    prefix="/auth",
    tags=["auth"],
    responses={404: {"description": "Not found"}},
)

auth_service = AuthService()

@auth_router.post('/signup')
async def signup(username: str, password: str):
    return await auth_service.signup(username, password)

@auth_router.get('/get_user')
async def get_user(username: str, user: User = Depends(get_current_user)):
    return await auth_service.get_user(username)

@auth_router.get('/get_all_users')
async def get_all_users():
    return await auth_service.get_all_users()

@auth_router.post('/login')
async def login(username: str, password: str):
    return await auth_service.login(username, password)

@auth_router.delete('/delete_user')
async def delete_user(username: str, user: User = Depends(get_current_user)):
    return await auth_service.delete_user(username)