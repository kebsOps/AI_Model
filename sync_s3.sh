#!/bin/bash

set -e

# Check if AWS credentials are set
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_DEFAULT_REGION" ] || [ -z "$S3_BUCKET_NAME" ]; then
    echo "Error: AWS credentials or S3 bucket name not set. Please set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION, and S3_BUCKET_NAME environment variables."
    exit 1
fi

# Function to sync with error handling
sync_with_retry() {
    local source=$1
    local destination=$2
    local retries=3
    local wait=5

    for i in $(seq 1 $retries); do
        if aws s3 sync "$source" "$destination" --endpoint-url https://s3.amazonaws.com; then
            return 0
        else
            echo "Sync attempt $i failed. Retrying in $wait seconds..."
            sleep $wait
        fi
    done

    echo "Failed to sync after $retries attempts."
    return 1
}

# Sync models from S3 to local
echo "Syncing models from S3..."
sync_with_retry "s3://$S3_BUCKET_NAME/models/Stable-diffusion" "/app/models/Stable-diffusion"
sync_with_retry "s3://$S3_BUCKET_NAME/models/Lora" "/app/models/Lora"
sync_with_retry "s3://$S3_BUCKET_NAME/models/CheckpointsXL" "/app/models/CheckpointsXL"

# Start the background sync process
echo "Starting background sync process..."
while true; do
    sync_with_retry "/app/models/Stable-diffusion" "s3://$S3_BUCKET_NAME/models/Stable-diffusion"
    sync_with_retry "/app/models/Lora" "s3://$S3_BUCKET_NAME/models/Lora"
    sync_with_retry "/app/models/CheckpointsXL" "s3://$S3_BUCKET_NAME/models/CheckpointsXL"
    sleep 3600  # Sleep for 1 hour before next sync
done