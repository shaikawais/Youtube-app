FROM python:3.13.5-slim

# Install ffmpeg and system dependencies
RUN apt-get update && apt-get install -y ffmpeg && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /backend

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Run FastAPI with debug support
CMD ["/bin/sh", "-c", "exec uvicorn main:app --host 0.0.0.0 --port 9000 --lifespan on"]
