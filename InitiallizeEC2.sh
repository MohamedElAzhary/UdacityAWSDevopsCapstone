#!/bin/bash
cd ~;
touch came.txt;
wget https://github.com/MohamedElAzhary/UdacityAWSDevopsCapstone/archive/refs/heads/main.zip;
unzip main.zip;
rm main.zip;
cd UdacityAWSDevopsCapstone-main;
bash installDocker.sh;