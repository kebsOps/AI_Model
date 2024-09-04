#!/bin/bash

# Run the S3 sync script
/app/sync_s3.sh

# Clone the assets repository
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-assets.git /app/repositories/stable-diffusion-webui-assets

# Start the Stable Diffusion Web UI
python3 launch.py --listen --enable-insecure-extension-access --port 7860 --server-name :: &

# Start the background sync process
while true; do
    aws s3 sync /app/models/Stable-diffusion s3://$S3_BUCKET_NAME/models/Stable-diffusion
    aws s3 sync /app/models/Lora s3://$S3_BUCKET_NAME/models/Lora
    aws s3 sync /app/models/CheckpointsXL s3://$S3_BUCKET_NAME/models/CheckpointsXL
    sleep 3600  # Sleep for 1 hour before next sync
done