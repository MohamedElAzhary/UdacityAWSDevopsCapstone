FROM python:3.7.3-stretch

## Step 1:
# Create a working directory
WORKDIR /app


## Step 2:
# Copy source code to working directory
COPY . /app/

RUN make all

## Step 4:
EXPOSE 80
EXPOSE 8000
EXPOSE 8080



## Step 5:
# Run app.py at container launch
CMD ["systemctl start apache2.service"]
