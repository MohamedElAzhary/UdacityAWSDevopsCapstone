#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Step 1:
# Create dockerpath
dockerpath=moazario/mlproject:mlimage

# Step 2:  
# Authenticate & tag
echo "Docker ID and Image: $dockerpath"

# Step 3:
# Push image to a docker repository
#docker login --username USERNAME
#docker push USERNAME/REPONAME:IMAGETAG
docker push $dockerpath