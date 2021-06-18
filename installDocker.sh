#!/usr/bin/env bash
echo "Creating Environment"
# Creating environment
make install


if !(getent group | grep docker);then sudo groupadd docker;fi;
sudo usermod -aG docker ubuntu #&& newgrp docker
exec 3<&0
echo "exec bash run_env.sh 0<&3 3<&-" | newgrp docker
