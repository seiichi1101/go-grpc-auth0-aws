#!/usr/bin/env bash

# Version=latest
ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')
ECR_PREFIX="${ACCOUNT_ID}.dkr.ecr.ap-northeast-1.amazonaws.com"

# echo $Version
echo $ACCOUNT_ID

aws ecr get-login-password | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.ap-northeast-1.amazonaws.com

# go grpc server
docker build -t go-grpc-server -f Dockerfile .
docker tag go-grpc-server:latest ${ECR_PREFIX}/go-grpc-server-test-ecr-repo/go-grpc-server:latest
docker push ${ECR_PREFIX}/go-grpc-server-test-ecr-repo/go-grpc-server:latest
