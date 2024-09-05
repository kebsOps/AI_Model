# Use a CUDA-compatible base image
FROM nvidia/cuda:11.7.1-runtime-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install system dependencies and Python
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    wget \
    ffmpeg \
    libsm6 \
    libxext6 \
    unzip \
    curl \
    iproute2 \
    && rm -rf /var/lib/apt/lists/* \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

# Enable IPv6
RUN echo "net.ipv6.conf.all.disable_ipv6 = 0" >> /etc/sysctl.conf \
    && echo "net.ipv6.conf.default.disable_ipv6 = 0" >> /etc/sysctl.conf \
    && echo "net.ipv6.conf.lo.disable_ipv6 = 0" >> /etc/sysctl.conf

# Set working directory
WORKDIR /app

# Clone the Stable Diffusion Web UI repository
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git .

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Create directories for models and Loras
RUN mkdir -p /app/models/Stable-diffusion \
    /app/models/Lora \
    /app/models/CheckpointsXL

# Copy the script to sync with S3
COPY sync_s3.sh /app/sync_s3.sh
RUN chmod +x /app/sync_s3.sh

# Copy the modified launch utils
COPY launch_utils_patch.py /app/modules/launch_utils_patch.py

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