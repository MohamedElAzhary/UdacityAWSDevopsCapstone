#!/usr/bin/env bash
echo "Creating Environment"
# Creating environment
make setup

echo "Sourcing Environment"
# Sourcing environment
. .ml-microservice/bin/activate

echo "Installing Dependencies"
make install

echo "Installing Docker"

sudo yum install -y docker


if !(getent group | grep docker);then sudo groupadd docker;fi;
sudo usermod -aG docker ec2-user #&& newgrp docker
exec 3<&0
echo "exec bash run_env.sh 0<&3 3<&-" | newgrp docker
