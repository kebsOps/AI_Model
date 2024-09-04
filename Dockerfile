# Use a smaller base image
FROM python:3.10-slim-buster

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    ffmpeg \
    libsm6 \
    libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone the Stable Diffusion Web UI repository
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git .

# Install Python dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Create directories for models and Loras
RUN mkdir -p /app/models/Stable-diffusion \
    /app/models/Lora \
    /app/models/CheckpointsXL

# Copy the script to sync with S3
COPY sync_s3.sh /app/sync_s3.sh
RUN chmod +x /app/sync_s3.sh

# Set up entry point
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Expose the port that the Web UI will run on
EXPOSE 7860

# These are placeholder environment variables. Actual values should be provided at runtime.
ENV AWS_ACCESS_KEY_ID=
ENV AWS_SECRET_ACCESS_KEY=
ENV AWS_DEFAULT_REGION=
ENV S3_BUCKET_NAME=

ENTRYPOINT ["/app/entrypoint.sh"]