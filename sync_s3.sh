#!/bin/bash

# Check if AWS credentials are set
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_DEFAULT_REGION" ] || [ -z "$S3_BUCKET_NAME" ]; then
    echo "Error: AWS credentials or S3 bucket name not set. Please set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION, and S3_BUCKET_NAME environment variables."
    exit 1
fi

# Configure AWS CLI with environment variables
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set default.region $AWS_DEFAULT_REGION

# Sync models from S3 to local
aws s3 sync s3://$S3_BUCKET_NAME/models/Stable-diffusion /app/models/Stable-diffusion
aws s3 sync s3://$S3_BUCKET_NAME/models/Lora /app/models/Lora
aws s3 sync s3://$S3_BUCKET_NAME/models/CheckpointsXL /app/models/CheckpointsXL

# Start the Stable Diffusion Web UI
python3 launch.py --listen --enable-insecure-extension-access &

# Sync local models back to S3 (run this in the background)
while true; do
    aws s3 sync /app/models/Stable-diffusion s3://$S3_BUCKET_NAME/models/Stable-diffusion
    aws s3 sync /app/models/Lora s3://$S3_BUCKET_NAME/models/Lora
    aws s3 sync /app/models/CheckpointsXL s3://$S3_BUCKET_NAME/models/CheckpointsXL
    sleep 3600  # Sleep for 1 hour before next sync
done