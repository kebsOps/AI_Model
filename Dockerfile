FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime

# Container Working Directory
WORKDIR /app

# Copy current directory contents /app 
COPY . /app

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*


# Install packages list in requirements.txt
COPY requirements.txt /app/
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir -r requirements.txt


COPY dreamshaper_8.safetensors /app/model/


EXPOSE 8000

# Run app.py when the container launches
CMD ["uvicorn", "app:app", "--host", "::", "--port", "80"]