from passlib.context import CryptContext

pwd_context = CryptContext(schemes=['bcrypt'], deprecated= 'auto')

class HashPwd():
    def encrypt(password: str):
        return pwd_context.hash(password)
    
    def verifyPwd(hashedPwd, originalPwd):
        return pwd_context.verify(originalPwd, hashedPwd)