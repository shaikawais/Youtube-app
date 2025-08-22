# YouTube-like Application

A YouTube-like application built with:
- **Frontend:** Flutter (Mobile + Web)
- **Backend:** FastAPI (Python)
- **Database:** Redis
- **Containerization:** Docker
- **Features:** Video streaming, real-time likes/comments/views, JWT authentication, and more.

---

## 🚀 Getting Started

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/yourusername/your-repo.git
cd your-repo
```

### 2️⃣ Start Docker Services

Make sure Docker is installed and running on your system.

From the base directory of the project:

```bash
docker-compose up --build
```
--This will start the Redis service and any other required containers.


### 3️⃣ Run the FastAPI Backend

Once Docker is running, start the FastAPI application:

```bash
cd backend
uvicorn main:app --host 0.0.0.0 --port 9000 --lifespan on
```
--By default, the backend will be available at http://127.0.0.1:9000:
--Access Swagger API documentation at http://127.0.0.1:9000/docs.

### VS Code Debug Configuration

To debug the FastAPI app inside Docker using VS Code, add the following to your `.vscode/launch.json`:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python Debugger: FastAPI (Docker)",
            "type": "debugpy",
            "request": "attach",
            "connect": {
                "host": "localhost",
                "port": 5678
            },
            "pathMappings": [
                {
                    "localRoot": "${workspaceFolder}/backend",
                    "remoteRoot": "/app"
                }
            ]
        }
    ]
}
```


### 4️⃣ Run the Flutter Frontend in Android studio code

```bash
flutter run
flutter run -d chrome
```

### 🛑 Stopping the Application

To stop the fastapi container run below command in new terminal
```bash
docker kill --signal=SIGTERM fastapi_backend
```

To stop all running Docker services:
```bash
docker-compose down
```


📂 Project Structure

├── backend/       # FastAPI backend code
├── frontend/      # Flutter app (mobile + web)
├── docker-compose.yml
└── README.md


🛠️ Prerequisites

Docker
Python 3.13.5
Flutter SDK
Redis (via Docker)