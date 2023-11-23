#!/bin/bash

# Prompt the user for the source Nexus registry
read -p "Enter the source Nexus repository URL (e.g., https://abc/nexus3/repository/ABC-Containers): " SOURCE_REGISTRY

# Validate input
if [ -z "$SOURCE_REGISTRY" ]; then
  echo "Error: Source Nexus repository URL is required."
  exit 1
fi

# Prompt the user for the image digest
read -p "Enter the image digest (e.g., sha256:fgregtrahgyshjthtgtbb): " IMAGE_DIGEST

# Validate input
if [ -z "$IMAGE_DIGEST" ]; then
  echo "Error: Image digest is required."
  exit 1
fi

# Pull the image from the source repository using the full URL to the digest
docker pull $SOURCE_REGISTRY/v2/blobs/$IMAGE_DIGEST

# AWS region for ECR
AWS_REGION="eu-west-2"

# Authenticate with AWS ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Tag the pulled image for AWS ECR
docker tag $SOURCE_REGISTRY/v2/blobs/$IMAGE_DIGEST $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$AWS_ECR_REPO:$IMAGE_DIGEST

# Push the image to AWS ECR
if docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$AWS_ECR_REPO:$IMAGE_DIGEST; then
  echo "Docker image $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$AWS_ECR_REPO:$IMAGE_DIGEST pushed to AWS ECR successfully."
else
  echo "Error: Unable to push Docker image to AWS ECR."
fi
