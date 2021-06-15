## The Makefile includes instructions on environment setup and lint tests
install:
		@wget -O /usr/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.16.3/hadolint-Linux-x86_64 \
		&& chmod +x /usr/bin/hadolint
		@wget -O /usr/bin/kubectl "https://dl.k8s.io/release/v1.21.1/bin/linux/amd64/kubectl" \
		&& chmod +x /usr/bin/kubectl
		@wget -O /usr/bin/minikube "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64" \
		&& chmod +x /usr/bin/minikube
		@wget -P /usr/bin/ https://download.docker.com/linux/static/stable/x86_64/docker-17.03.0-ce.tgz
		@sudo apt install unzip

lint:
		/usr/bin/hadolint Dockerfile

deploy:
		iptables -I INPUT -p tcp --dport 12345 --syn -j ACCEPT
		service iptables save
		apt-get update -y
		apt-get install unzip awscli -y
		apt-get install apache2 -y
		wget -P /var/www/html/ https://github.com/MohamedElAzhary/UdacityAWSDevopsCapstone/raw/main/udacity.zip
		unzip -o /var/www/html/udacity.zip

all: install lint deploy
