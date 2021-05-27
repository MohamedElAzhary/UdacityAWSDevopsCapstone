## The Makefile includes instructions on environment setup and lint tests
# Create and activate a virtual environment
# Install dependencies in requirements.txt
# Dockerfile should pass hadolint
# app.py should pass pylint
# (Optional) Build a simple integration test

setup:
	echo "Creating Environment"
	@if !(test -f .ml-microservice/bin/activate);then python3 -m venv .ml-microservice;fi;

install:
	@pip install --upgrade pip
	@pip install -r requirements.txt
	@wget -O ./.ml-microservice/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64 \
	&& chmod +x .ml-microservice/bin/hadolint
	@wget -O ./.ml-microservice/bin/kubectl "https://dl.k8s.io/release/v1.21.1/bin/linux/amd64/kubectl" \
	&& chmod +x .ml-microservice/bin/kubectl
	@wget -O ./.ml-microservice/bin/minikube "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64" \
	&& chmod +x .ml-microservice/bin/minikube
	@wget -P ./.ml-microservice/bin/ https://download.docker.com/linux/static/stable/x86_64/docker-17.03.0-ce.tgz
	#@tar -xzvf ./.ml-microservice/bin/docker-17.03.0-ce.tgz -C ./.ml-microservice/bin/
	#@rm -f ./.ml-microservice/bin/docker-17.03.0-ce.tgz
	#@mkdir ./.ml-microservice/bin/tmp
	#@cp -r ./.ml-microservice/bin/docker/* ./.ml-microservice/bin/tmp
	#@rm -f -r ./.ml-microservice/bin/docker
	#@cp -r ./.ml-microservice/bin/tmp/* ./.ml-microservice/bin/
	#@rm -f -r ./.ml-microservice/bin/tmp
	#@if (test -f ./.ml-microservice/bin/docker);then chmod +x ./.ml-microservice/bin/docker;fi;
	#sudo yum install -y conntrack

setupDocker:
	sudo yum install -y docker
	if !(getent group | grep docker);then sudo groupadd docker;fi;

test:
	# Additional, optional, tests could go here
	#python -m pytest -vv --cov=myrepolib tests/*.py
	#python -m pytest --nbval notebook.ipynb

lint:
	@./.ml-microservice/bin/hadolint Dockerfile
	@pylint --disable=R,C,W1203 app.py

all: setup install lint
