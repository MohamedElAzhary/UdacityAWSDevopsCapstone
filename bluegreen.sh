#!/bin/bash

#Searching stack Outputs for TargetGroupARN
length=$((aws cloudformation describe-stacks --stack-name P5Stack --query " Stacks[].Outputs[]") | jq '.| length')
end=$(expr $length - 1)
for ((i=0; i<=$end; i++))
do
    OKEY=$(aws cloudformation describe-stacks --stack-name P5Stack --query " Stacks[].Outputs[$i].OutputKey" | jq ".[]" | tr -d '"')
    OVALUE=$(aws cloudformation describe-stacks --stack-name P5Stack --query " Stacks[].Outputs[$i].OutputValue" | jq ".[]" | tr -d '"')
    if [[ $OKEY == "LBTargetGroup" ]]
    then
        TargetGroupARN=$OVALUE
        echo "TargetGroup in P5Stack is $TargetGroupARN"
    fi
done




# Listing Hosts registered in TargetGroupARN
# Deregistering any Existing Hosts in TargetGroupARN
length=$((aws elbv2 describe-target-health --target-group-arn $TargetGroupARN --query " TargetHealthDescriptions[].Target.Id") | jq '.| length')
end=$(expr $length - 1)
for ((i=0; i<=$end; i++))
do  
    (aws elbv2 describe-target-health --target-group-arn $TargetGroupARN --query " TargetHealthDescriptions[$i].Target.Id" | tr -d '"')
    if [[ "10.0.2.15" == $(aws elbv2 describe-target-health --target-group-arn $TargetGroupARN --query " TargetHealthDescriptions[$i].Target.Id" | tr -d '"') ]]
    then
        echo "HOST FOUND at line $i"
        aws elbv2 deregister-targets --target-group-arn --targets Id=10.0.2.15,Port=8000,AvailabilityZone="us-west-2a"
    fi
    if [[ "10.0.3.15" == $(aws elbv2 describe-target-health --target-group-arn $TargetGroupARN --query " TargetHealthDescriptions[$i].Target.Id" | tr -d '"') ]]
    then
        echo "HOST FOUND at line $i"
        aws elbv2 deregister-targets --target-group-arn --targets Id=10.0.3.15,Port=8000,AvailabilityZone="us-west-2b"
    fi
done

aws elbv2 register-targets --target-group-arn --targets Id=10.0.2.15,Port=8000,AvailabilityZone="us-west-2a"
aws elbv2 register-targets --target-group-arn --targets Id=10.0.3.15,Port=8000,AvailabilityZone="us-west-2b"
aws elbv2 deregister-targets --target-group-arn --targets Id=10.0.2.15,Port=8000,AvailabilityZone="us-west-2a"
aws elbv2 deregister-targets --target-group-arn --targets Id=10.0.3.15,Port=8000,AvailabilityZone="us-west-2b"


aws cloudformation describe-stacks --stack-name P5Stack --query " Stacks[].Outputs[]"
aws elbv2 describe-target-health --target-group-arn arn:aws:elasticloadbalancing:us-west-2:898576305101:targetgroup/P5Sta-P5Tar-10T8MFUP5F3F/caeac83d735259e1 --query " TargetHealthDescriptions[0].Target.Id"

#Deploy Blue if no EC2 is available
if (aws ec2 describe-instances --query " Reservations[].Instances[].PrivateIpAddress" | grep "10.0.2.15")
then
    if (aws ec2 describe-instances --query " Reservations[].Instances[].PrivateIpAddress" | grep "10.0.3.15")
    then
        #
    else
        aws cloudformation create-stack --stack-name  --template-body file://create_ec2.yml --parameters ParameterKey=IPAd,ParameterValue=10.0.3.15  --region us-west-2 --on-failure DO_NOTHING
        #aws cloudformation create-stack --stack-name LBStack --template-body file://create_stack.yml --region us-west-2 --on-failure DO_NOTHING        
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