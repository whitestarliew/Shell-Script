#!/bin/bash

# Set your source Docker registry and AWS ECR registry details
SOURCE_REGISTRY="https://abc/nexus3"
AWS_REGION="your-aws-region"
AWS_ACCOUNT_ID="your-aws-account-id"

# Prompt the user for image details
read -p "Enter the image name: " IMAGE_NAME
read -p "Enter the image tag: " IMAGE_TAG

# Validate input
if [ -z "$IMAGE_NAME" ] || [ -z "$IMAGE_TAG" ]; then
  echo "Error: Image name and tag are required."
  exit 1
fi

# Prompt the user for AWS ECR details
read -p "Enter the AWS ECR repository name: " AWS_ECR_REPO

# Validate input
if [ -z "$AWS_ECR_REPO" ]; then
  echo "Error: AWS ECR repository name is required."
  exit 1
fi

# Authenticate with the source Docker registry
docker login $SOURCE_REGISTRY

# Pull the image from the source registry
docker pull $SOURCE_REGISTRY/$IMAGE_NAME:$IMAGE_TAG

# Authenticate with AWS ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Tag the pulled image for AWS ECR
docker tag $SOURCE_REGISTRY/$IMAGE_NAME:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$AWS_ECR_REPO/$IMAGE_NAME:$IMAGE_TAG

# Push the image to AWS ECR
if docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$AWS_ECR_REPO/$IMAGE_NAME:$IMAGE_TAG; then
  echo "Docker image $IMAGE_NAME:$IMAGE_TAG pushed to AWS ECR successfully."
else
  echo "Error: Unable to push Docker image to AWS ECR."
fi
