#!/bin/bash

# This script does the following
# 1- Create an EC2 instance using fetched exported outputs, Run on it the ml flask server
# 2- Fetch exported outputs from P5Stack. i.e. (TargetGroupARN, PublicSubne1, LBSecurityGroup)
# 3- Register the new EC2 instance in the Target Group
# 4- If a previous EC2 instance exists, it will be de-registered from Target Group and terminated.
#

# Create EC2 instance
if [[ $(aws cloudformation describe-stacks | grep "One-Stack") ]]
then
    echo "One Stack Exists"
    Order="Two"
else
    echo "One Stack does not Exist"
    Order="One"
fi

echo "Creating $Order-Stack"
aws cloudformation create-stack --stack-name "$Order-Stack" --template-body file://create_ec2.yml --region us-west-2 --on-failure DO_NOTHING
echo "Green EC2 has been created in $Order-Stack"
echo ""

echo "P5Stack Exported Outputs"
echo ""
# Searching stack Outputs for TargetGroupARN
if [[ $(aws cloudformation describe-stacks | grep "P5Stack") ]]
then
    length=$((aws cloudformation describe-stacks --stack-name "P5Stack" --query " Stacks[].Outputs[]") | jq '.| length')
    end=$(expr $length - 1)
    for ((i=0; i<=$end; i++))
    do
        OEXPORTNAME=$(aws cloudformation describe-stacks --stack-name "P5Stack" --query " Stacks[].Outputs[$i].ExportName" | jq ".[]" | tr -d '"')
        OVALUE=$(aws cloudformation describe-stacks --stack-name "P5Stack" --query " Stacks[].Outputs[$i].OutputValue" | jq ".[]" | tr -d '"')
        #echo "OEXPORTNAME=$OEXPORTNAME has OVALUE=$OVALUE"
        if [[ $OEXPORTNAME == "P5Stack-P5TargetGroup" ]]   #Needs MOd
        then
            LBTargetGroup=$OVALUE
            echo "TargetGroup in P5Stack is $LBTargetGroup"
        fi
        
        if [[ $OEXPORTNAME == "P5Stack-EC2HTTPrule" ]]
        then
            LBSecurityGroup=$OVALUE
            echo "SecurityGroup in P5Stack is $LBSecurityGroup"
        fi
      
        if [[ $OEXPORTNAME == "P5Stack-EC2SecGroup" ]]
        then
            EC2SecurityGroup=$OVALUE
            echo "EC2 SecurityGroup in P5Stack is $EC2SecurityGroup"
        fi
        
        if [[ $OEXPORTNAME == "P5Stack-PublicSubnet1" ]]
        then
            PublicSubnet1=$OVALUE
            echo "PublicSubnet1 in P5Stack is $PublicSubnet1"
        fi
        
        if [[ $OEXPORTNAME == "P5Stack-LBDNSName" ]]
        then
            LBDNSName=$OVALUE
            echo "LBDNSName in P5Stack is $LBDNSName"
        fi
    done
fi

echo "Waiting for 3 minutes till EC2 is created"
echo ""
sleep 3m

echo "Fetching $Order-Stack EC2 Outputs"
# Register new EC2 at Target Group
length=$((aws cloudformation describe-stacks --stack-name "$Order-Stack" --query " Stacks[].Outputs[]") | jq '.| length')
end=$(expr $length - 1)
for ((i=0; i<=$end; i++))
do
    OEXPORTNAME=$(aws cloudformation describe-stacks --stack-name "$Order-Stack" --query " Stacks[].Outputs[$i].ExportName" | jq ".[]" | tr -d '"')
    OVALUE=$(aws cloudformation describe-stacks --stack-name "$Order-Stack" --query " Stacks[].Outputs[$i].OutputValue" | jq ".[]" | tr -d '"')
    #echo "OEXPORTNAME=$OEXPORTNAME has OVALUE=$OVALUE"
    if [[ $OEXPORTNAME == "$Order-Stack-EC2PRIVIP" ]]
    then
        EC2PRIVIP=$OVALUE
        echo "EC2PRIVIP in $Order-Stack is $EC2PRIVIP"
        aws elbv2 register-targets --target-group-arn $LBTargetGroup --targets Id=$EC2PRIVIP,Port=8000,AvailabilityZone="us-west-2a"
        echo "$EC2PRIVIP from $Order-Stack is registered"
    fi
    
    if [[ $OEXPORTNAME == "$Order-Stack-EC2ID" ]]
    then
        EC2ID=$OVALUE
        echo "EC2ID in $Order-Stack is $EC2ID"
        aws ec2 create-tags --resources $EC2ID --tags Key="Name",Value="Blue"
        echo "$EC2ID from $Order-Stack has been tagged Blue"
    fi

done

echo ""

# Deregister old EC2 and delete Old EC2 stack

if [[ $Order == "Two" ]]
then
    if [[ $(aws cloudformation describe-stacks | grep "One-Stack") ]]
    then
        echo "Fetching Old One-Stack EC2 Outputs"
        length=$((aws cloudformation describe-stacks --stack-name "One-Stack" --query " Stacks[].Outputs[]") | jq '.| length')
        end=$(expr $length - 1)
        for ((i=0; i<=$end; i++))
        do
            OEXPORTNAME=$(aws cloudformation describe-stacks --stack-name "One-Stack" --query " Stacks[].Outputs[$i].ExportName" | jq ".[]" | tr -d '"')
            OVALUE=$(aws cloudformation describe-stacks --stack-name "One-Stack" --query " Stacks[].Outputs[$i].OutputValue" | jq ".[]" | tr -d '"')
            if [[ $OEXPORTNAME == "One-Stack-EC2PRIVIP" ]]
            then
                EC2PRIVIP=$OVALUE
                echo "EC2PRIVIP in One-Stack is $EC2PRIVIP"
                echo "Deregistering Old EC2 from Target Group $LBTargetGroup"
                aws elbv2 deregister-targets --target-group-arn $LBTargetGroup --targets Id=$EC2PRIVIP,Port=8000,AvailabilityZone="us-west-2a"
                echo "$EC2PRIVIP from One-Stack is deregistered"
            fi
            if [[ $OEXPORTNAME == "One-Stack-EC2ID" ]]
            then
                OldEC2ID=$OVALUE
                #echo "Terminating OldEC2I=$OldEC2ID in One-Stack"
                #aws ec2 terminate-instances --instance-ids $OldEC2ID
                #echo "OldEC2I=$OldEC2ID in One-Stack is Terminated"
                
            fi
        done
    fi
fi

echo ""


if [[ $Order == "One" ]]
then
    if [[ $(aws cloudformation describe-stacks | grep "Two-Stack") ]]
    then
        echo "Fetching Old Two-Stack EC2 Outputs"
        length=$((aws cloudformation describe-stacks --stack-name "Two-Stack" --query " Stacks[].Outputs[]") | jq '.| length')
        end=$(expr $length - 1)
        for ((i=0; i<=$end; i++))
        do
            OEXPORTNAME=$(aws cloudformation describe-stacks --stack-name "Two-Stack" --query " Stacks[].Outputs[$i].ExportName" | jq ".[]" | tr -d '"')
            OVALUE=$(aws cloudformation describe-stacks --stack-name "Two-Stack" --query " Stacks[].Outputs[$i].OutputValue" | jq ".[]" | tr -d '"')
            if [[ $OEXPORTNAME == "Two-Stack-EC2PRIVIP" ]]
            then
                EC2PRIVIP=$OVALUE
                echo "EC2PRIVIP in Two-Stack is $EC2PRIVIP"
                echo "Deregistering Old EC2 from Target Group $LBTargetGroup"
                aws elbv2 deregister-targets --target-group-arn $LBTargetGroup --targets Id=$EC2PRIVIP,Port=8000,AvailabilityZone="us-west-2a"
                echo "$EC2PRIVIP from Two-Stack is deregistered"
            fi
            
            if [[ $OEXPORTNAME == "Two-Stack-EC2ID" ]]
            then
                OldEC2ID=$OVALUE
                #echo "Terminating OldEC2I=$OldEC2ID in Two-Stack"
                #aws ec2 terminate-instances --instance-ids $OldEC2ID
                #echo "OldEC2I=$OldEC2ID in Two-Stack is Terminated"
                
            fi
            
        done
    fi
fi

echo ""




if [[ ($Order == "Two") && $(aws cloudformation describe-stacks | grep "One-Stack") ]]
then
    echo "Terminating OldEC2I=$OldEC2ID in One-Stack"
    echo "Deleting Old Stack : One-Stack"
    aws cloudformation delete-stack --stack-name One-Stack
    echo "Old Stack : One-Stack is Deleted"

elif [[ ($Order == "One") && $(aws cloudformation describe-stacks | grep "Two-Stack") ]]
then
    echo "Terminating OldEC2I=$OldEC2ID in Two-Stack"
    echo "Deleting Old Stack : Two-Stack"
    aws cloudformation delete-stack --stack-name Two-Stack
    echo "Old Stack : Two-Stack is Deleted"
else
    echo "Not Deleting Stacks"
fi

                
