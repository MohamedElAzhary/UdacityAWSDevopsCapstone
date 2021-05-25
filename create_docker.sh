# This script  installs docker
wget -P ./.ml-microservice/bin/ https://download.docker.com/linux/static/stable/x86_64/docker-17.03.0-ce.tgz
cd ./.ml-microservice/bin
tar -xzvf docker-17.03.0-ce.tgz
rm -f docker-17.03.0-ce.tgz
mkdir tmp
cp -r ./docker/* ./tmp
rm -f -r ./docker
cp -r ./tmp/* .
rm -f -r ./tmp