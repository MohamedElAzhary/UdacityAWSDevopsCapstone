#!/usr/bin/env bash

## Complete the following steps to get Docker running locally

# Step 1:
# Build image and add a descriptive tag
imageName=moazario/mlproject:mlimage

if(docker image ls | grep mlimage)
then 
    echo "Removing existing image"
    docker rmi -f $imageName
fi

echo "Building image"
docker build -t $imageName .


# Step 2: 
# List docker images
echo "Existing Images"
docker image ls

# Step 3: 
# Run flask app

echo "Running image"
docker run -it -p 8000:80 $imageName