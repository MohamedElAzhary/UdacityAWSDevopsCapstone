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
