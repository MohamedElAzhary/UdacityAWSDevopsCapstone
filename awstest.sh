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


aws elbv2 register-targets \
    --target-group-arn arn:aws:elasticloadbalancing:us-west-2:123456789012:targetgroup/my-tcp-ip-targets/8518e899d173178f \
    --targets Id=10.0.1.15 Id=10.0.1.23
    
aws elbv2 describe-load-balancers
aws elbv2 describe-target-groups
