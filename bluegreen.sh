#!/bin/bash

#Deploy Blue if no EC2 is available
if (aws ec2 describe-instances --query " Reservations[].Instances[].PrivateIpAddress" | grep "10.0.2.15")
then
    if (aws ec2 describe-instances --query " Reservations[].Instances[].PrivateIpAddress" | grep "10.0.3.15")
    then
        
    else
        aws cloudformation create-stack --stack-name  --template-body file://create_ec2.yml --parameters ParameterKey=IPAd,ParameterValue=10.0.3.15  --region us-west-2 --on-failure DO_NOTHING
    fi
else
    if (aws ec2 describe-instances --query " Reservations[].Instances[].PrivateIpAddress" | grep "10.0.3.15")
    then
        aws cloudformation create-stack --stack-name  --template-body file://create_ec2.yml --parameters ParameterKey=IPAd,ParameterValue=10.0.2.15  --region us-west-2 --on-failure DO_NOTHING
    else
        aws cloudformation create-stack --stack-name  --template-body file://create_ec2.yml --parameters ParameterKey=IPAd,ParameterValue=10.0.2.15  --region us-west-2 --on-failure DO_NOTHING                
    fi
fi


(aws ec2 describe-instances --query " Reservations[].Instances[].Tags[]") | jq -c '.[] | select( .Key == "Name")' | jq '.Value'
length=$((aws ec2 describe-instances --query " Reservations[].Instances[]") | jq '.| length')
for i in {0..(length-1)}
do
    echo "hey"
done

aws ec2 create-tags --resources i-08cb59d54682bfd37 --tags Key="Name",Value="blue"