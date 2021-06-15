#!/usr/bin/env bash

sudo systemctl start docker

echo "Linting Code"
make lint

# Creating image path
imageName=moazario/mlproject:mlimage

if !(docker image ls | grep mlimage)
then 
    echo "Building Docker image from this directory"
    # Build image and add a descriptive tag
    docker build -t $imageName .

fi


echo "Listing existing docker images"
# List docker images
docker image ls


export PATH=$PATH:./.ml-microservice/bin

echo "Starting Kubernetes"
minikube start --driver=docker
sleep 1m

if(kubectl get pods | grep mlpod)
then 
    echo "Deleting running pod"
    kubectl delete pod mlpod
    sleep 1m
fi

echo "Running image inside mlpod"
# Run image inside a pod
kubectl run mlpod --image=$imageName
sleep 1m


echo "Listing existing pods"
# List kubernetes pods
kubectl get pods

sleep 2m

echo "Forwarding host port 8000 to container port 80"
# Forward Host port 8000 to container Port 80
kubectl port-forward mlpod 8000:80 --address 0.0.0.0


echo "Script ran successfully"
