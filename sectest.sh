#!/bin/bash
if [[ $(aws cloudformation describe-stacks --stack-name P5Stack) ]]
then
    echo "Stack Exists"
else
    echo "Stack does not Exist"
fi