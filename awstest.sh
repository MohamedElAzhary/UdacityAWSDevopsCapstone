#!/bin/bash
#test file

length=$((aws ec2 describe-instances --query " Reservations[].Instances[]") | jq '.| length')
end=$(expr $length - 1)

for ((i=0; i<=$end; i++))
do
    ID=$((aws ec2 describe-instances --query " Reservations[$i].Instances[].InstanceId")| jq '.[]'| tr -d '"')
    NAME=$((aws ec2 describe-instances --query " Reservations[$i].Instances[].Tags[]") | jq -c '.[] | select( .Key == "Name")' | jq '.Value'| tr -d '"')
    echo "ID=$ID has NAME=$NAME"
    if [[ $ID == "i-034e5a4a3b27756a7" ]]
    then
        echo "Green Found"
    fi
done

length=$((aws ec2 describe-instances --query " Reservations[].Instances[]") | jq '.| length')
end=$(expr $length - 1)
for ((i=0; i<=$end; i++))
do
    aws elbv2 describe-target-health --target-group-arn  --query " TargetHealthDescriptions[$i].Target.Id"
done

length=$((aws cloudformation describe-stacks --stack-name LBStack --query " Stacks[].Outputs[]") | jq '.| length')
end=$(expr $length - 1)
for ((i=0; i<=$end; i++))
do
    OKEY=$(aws cloudformation describe-stacks --stack-name LBStack --query " Stacks[].Outputs[$i].OutputKey" | jq ".[]" | tr -d '"')
    OVALUE=$(aws cloudformation describe-stacks --stack-name LBStack --query " Stacks[].Outputs[$i].OutputValue" | jq ".[]" | tr -d '"')
    echo "OKEY=$OKEY has OVALUE=$OVALUE"
    if [[ $OKEY == "" ]]
    then
        echo "Green Found"
    fi
done


aws elbv2 register-targets --target-group-arn --targets Id=10.0.2.15,Port=8000,AvailabilityZone="us-west-2a"
aws elbv2 register-targets --target-group-arn --targets Id=10.0.3.15,Port=8000,AvailabilityZone="us-west-2b"
aws elbv2 deregister-targets --target-group-arn --targets Id=10.0.2.15,Port=8000,AvailabilityZone="us-west-2a"
aws elbv2 deregister-targets --target-group-arn --targets Id=10.0.3.15,Port=8000,AvailabilityZone="us-west-2b"
    
aws elbv2 describe-target-groups --query " TargetGroups[].TargetGroupArn"
    
aws elbv2 describe-load-balancers
aws elbv2 describe-target-groups

aws cloudformation describe-stacks --stack-name LBStack --query " Stacks[].Outputs[]"
aws elbv2 describe-target-health --target-group-arn arn:aws:elasticloadbalancing:us-west-2:898576305101:targetgroup/P5Sta-P5Tar-10T8MFUP5F3F/caeac83d735259e1 --query " TargetHealthDescriptions[0].Target.Id"

aws elbv2 describe-target-health --target-group-arn arn:aws:elasticloadbalancing:us-west-2:898576305101:targetgroup/LBSta-P5Tar-1IDUVPU21LDC2/0fa893c0502527db