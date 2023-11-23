#!/bin/bash

# Set your source Docker registry and AWS ECR registry details
SOURCE_REGISTRY="https://abc/nexus3"
AWS_REGION="your-aws-region"
AWS_ACCOUNT_ID="your-aws-account-id"

# Prompt the user for image details
read -p "Enter the image digest (e.g., sha256:blablablablabla): " IMAGE_DIGEST

# Validate input
if [ -z "$IMAGE_DIGEST" ]; then
  echo "Error: Image digest is required."
  exit 1
fi

# Extract the image name from the digest
IMAGE_NAME=$(echo $IMAGE_DIGEST | cut -d ':' -f 1)

# Authenticate with the source Docker registry
docker login $SOURCE_REGISTRY

# Pull the image from the source registry using the digest
docker pull $SOURCE_REGISTRY/$IMAGE_NAME@$IMAGE_DIGEST

# Authenticate with AWS ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Tag the pulled image for AWS ECR
docker tag $SOURCE_REGISTRY/$IMAGE_NAME@$IMAGE_DIGEST $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$AWS_ECR_REPO/$IMAGE_NAME:$IMAGE_DIGEST

# Push the image to AWS ECR
if docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$AWS_ECR_REPO/$IMAGE_NAME:$IMAGE_DIGEST; then
  echo "Docker image $IMAGE_NAME:$IMAGE_DIGEST pushed to AWS ECR successfully."
else
  echo "Error: Unable to push Docker image to AWS ECR."
fi
