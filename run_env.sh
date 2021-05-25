#!/usr/bin/env bash

#Creating image path
imageName=moazario/mlproject:ml

echo "Building Docker image from this directory"
# Build image and add a descriptive tag
docker build -t $imageName .

echo "Listing existing docker images"
# List docker images
docker image ls

echo "Starting Kubernetes"
minikube start
sleep 1m


echo "Running image inside mlpod"
# Run image inside a pod
kubectl run mlpod --image=$imageName
sleep 1m


echo "Listing existing pods"
# List kubernetes pods
kubectl get pods


echo "Forwarding host port 8000 to container port 80"
# Forward Host port 8000 to container Port 80
kubectl port-forward mlpod 8000:80

echo "Script ran successfully"