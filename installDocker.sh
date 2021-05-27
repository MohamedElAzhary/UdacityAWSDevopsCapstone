sudo yum install -y docker
if !(getent group | grep docker);then sudo groupadd docker;fi;
sudo usermod -aG docker ec2-user 
# newgrp docker
