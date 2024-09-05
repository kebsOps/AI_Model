#!/bin/bash

# Run the S3 sync script in the background
/app/sync_s3.sh &

# Apply the launch utils patch
cat /app/modules/launch_utils_patch.py >> /app/modules/launch_utils.py

# Start the Stable Diffusion Web UI
python3 launch.py --listen --enable-insecure-extension-access --port 7860 --server-name '[::0]' --no-half --skip-torch-cuda-test --allow-code --api