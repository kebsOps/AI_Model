# Stable Diffusion Web UI on Salad Cloud

This project sets up Stable Diffusion Web UI to run on Salad Cloud, with support for S3 model synchronization and IPv6 compatibility.

## Table of Contents

- [Stable Diffusion Web UI on Salad Cloud](#stable-diffusion-web-ui-on-salad-cloud)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
  - [Usage](#usage)
  - [File Structure](#file-structure)
  - [Customization](#customization)
  - [Troubleshooting](#troubleshooting)
  - [Contributing](#contributing)
  - [License](#license)

## Overview

This project deploys the Automatic1111 Stable Diffusion Web UI on Salad Cloud, with the following features:

- IPv6 compatibility for Salad Cloud
- S3 synchronization for models and checkpoints
- Dockerized environment for easy deployment
- Automatic retry mechanism for S3 operations

## Prerequisites

- Docker
- AWS account with S3 bucket
- Salad Cloud account

## Setup

1. Clone this repository:
   ```
   git clone https://your-repository-url.git
   cd stable-diffusion-salad
   ```

2. Set up your AWS credentials and S3 bucket information. You'll need to provide these as environment variables when deploying to Salad Cloud:
   - AWS_ACCESS_KEY_ID
   - AWS_SECRET_ACCESS_KEY
   - AWS_DEFAULT_REGION
   - S3_BUCKET_NAME

3. Build the Docker image:
   ```

   docker build --platform linux/amd64 -t dreamshaper:v15 .

   ```

4. Push the Docker image to a registry accessible by Salad Cloud.

5. Deploy the container on Salad Cloud, ensuring you set the required environment variables.

## Usage

Once deployed, you can access the Stable Diffusion Web UI through the URL provided by Salad Cloud. The Web UI will be available on port 7860.

The S3 synchronization script will automatically download models from your S3 bucket on startup and periodically sync changes back to S3.

## File Structure

- `Dockerfile`: Defines the Docker image for the project
- `requirements.txt`: Lists Python dependencies
- `entrypoint.sh`: The entry point script for the Docker container
- `sync_s3.sh`: Handles S3 synchronization
- `launch_utils_patch.py`: Patches the launch utils for better IPv6 support

## Customization

- To add or remove Python dependencies, modify the `requirements.txt` file.
- To change S3 sync behavior, edit the `sync_s3.sh` script.
- For changes to the Stable Diffusion Web UI itself, modify the appropriate files after cloning in the Dockerfile.

## Troubleshooting

- Check the logs provided by Salad Cloud for any error messages.
- Ensure all required environment variables are set correctly.
- Verify that your S3 bucket is accessible and has the correct permissions.
- If facing IPv6 issues, ensure your Salad Cloud configuration supports IPv6.

## Contributing

Contributions to improve the project are welcome. Please follow these steps:

1. Fork the repository
2. Create a new branch for your feature
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

For more information on the Stable Diffusion Web UI, visit the [official repository](https://github.com/AUTOMATIC1111/stable-diffusion-webui).

For Salad Cloud documentation, visit [Salad Cloud Documentation](https://docs.salad.com/).