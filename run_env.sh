#!/usr/bin/env bash

echo "Creating Environment"
# Creating environment
make setup

echo "Sourcing Environment"
# Sourcing environment
. .ml-microservice/bin/activate

echo "Installing Dependencies"
make install

echo "Linting Code"
make lint

# Creating image path
imageName=moazario/mlproject:ml

echo "Building Docker image from this directory"
# Build image and add a descriptive tag
./.ml-microservice/bin/docker build -t $imageName .

echo "Listing existing docker images"
# List docker images
./.ml-microservice/bin/docker image ls

echo "Starting Kubernetes"
./.ml-microservice/bin/minikube start
sleep 1m


echo "Running image inside mlpod"
# Run image inside a pod
./.ml-microservice/bin/kubectl run mlpod --image=$imageName
sleep 1m


echo "Listing existing pods"
# List kubernetes pods
./.ml-microservice/bin/kubectl get pods


echo "Forwarding host port 8000 to container port 80"
# Forward Host port 8000 to container Port 80
./.ml-microservice/bin/kubectl port-forward mlpod 8000:80

echo "Script ran successfully"