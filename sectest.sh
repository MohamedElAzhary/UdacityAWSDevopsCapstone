#!/bin/bash

aws cloudformation create-stack --stack-name P5Stack --template-body file://create_stack.yml --region us-west-2 --on-failure DO_NOTHING

sleep 5m

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

