FROM python:3.7.3-stretch

## Step 1:
# Create a working directory
WORKDIR /app


## Step 2:
# Copy source code to working directory
COPY . /app/

RUN iptables -I INPUT -p tcp --dport 12345 --syn -j ACCEPT
RUN service iptables save
RUN apt-get update -y
RUN apt-get install unzip awscli -y
RUN apt-get install apache2 -y
RUN cd /var/www/html &&\
     wget https://github.com/MohamedElAzhary/UdacityAWSDevopsCapstone/raw/main/udacity.zip
RUN cd /var/www/html &&\
     unzip -o udacity.zip




## Step 4:
EXPOSE 80
EXPOSE 8000
EXPOSE 8080



## Step 5:
# Run app.py at container launch
CMD ["systemctl start apache2.service"]
