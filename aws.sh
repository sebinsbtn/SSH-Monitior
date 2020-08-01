#!/bin/bash
##Author Sebin Sebastian sebin.sbtn@gmail.com
##this is a test comment
if [ -z "$1" ]
then
	profile='default'
else
	profile=$1
fi
echo $profile

echo "Input AMI ID"
read imageid
if [ -z "$imageid" ]
then
	echo "AMI ID not provided"
	exit 0
fi

echo $imageid
echo "Creating instance"
aws ec2 create-key-pair --key-name new-key-for-monitoringapp --query 'KeyMaterial' --output text > new-key-for-monitoringapp.pem --profile $profile
chmod 400 new-key-for-monitoringapp.pem

aws ec2 describe-subnets --max-items 1 --profile $profile |grep subnet- |cut -f2- -d: |tail -n +2 | sed 's/\"//' | sed 's/\,//' |sed 's/\"//' |sed 's/\ //' >> subnet-id.out
subnetid=`cat subnet-id.out`

aws ec2 run-instances --image-id $imageid --key-name new-key-for-monitoringapp --instance-type t2.micro --placement AvailabilityZone=us-east-1b  --count 1 --associate-public-ip-address --subnet-id $subnetid--profile $profile --region us-east-1 >> createec2.log
echo "Instance Created"

sleep 3m

cat createec2.log |grep "InstanceId" >> instanceid.first
cat instanceid.first |cut -f2- -d: >> instanceid.second
cat instanceid.second |sed 's/ //' | sed 's/\"//' | sed 's/\"//' | sed 's/\,//' >>instanceid

echo "Waiting for instanceId"
sleep 3s

input=`cat instanceid`
echo $input
echo "Got instanceId"

echo "Waiting for ip address"
aws ec2 describe-instances --instance-ids $input --profile $profile --region us-east-1 >>ipaddress.first
aws ec2 create-security-group --group-name monitoringappsg --description "Security group for monitoring app" --output text --profile $profile >>securitygrp.out

aws ec2 authorize-security-group-ingress --group-name monitoringappsg --protocol tcp --port 22 --cidr 0.0.0.0/0 --profile $profile
aws ec2 authorize-security-group-ingress --group-name monitoringappsg --protocol tcp --port 80 --cidr 0.0.0.0/0 --profile $profile
aws ec2 authorize-security-group-ingress --group-name monitoringappsg --protocol tcp --port 81 --cidr 0.0.0.0/0 --profile $profile
aws ec2 authorize-security-group-ingress --group-name monitoringappsg --protocol tcp --port 82 --cidr 0.0.0.0/0 --profile $profile
aws ec2 authorize-security-group-ingress --group-name monitoringappsg --protocol tcp --port 1492 --cidr 0.0.0.0/0 --profile $profile

securitygrp=`cat securitygrp.out`

aws ec2 modify-instance-attribute --instance-id $input --groups $securitygrp --profile $profile --region us-east-1

sleep 3s

cat ipaddress.first | grep "PublicIpAddress" >>ipaddress.second

cat ipaddress.second |cut -f2- -d: >> ipaddress.third

cat ipaddress.third | sed 's/_//' | sed 's/-//' | sed 's/\"//' | sed 's/\"//' | sed 's/\,//' | sed 's/\ //' >> ipaddress

input2=`cat ipaddress`
echo $input2
echo "Got IP Address"
sleep 3s


rsync -avz -e "ssh -o StrictHostKeyChecking=no -i "new-key-for-monitoringapp.pem" -v" --delete --rsync-path="sudo rsync" Server/ ubuntu@$input2:/home/ubuntu/Server$

echo "Copied Files"
sleep 3s

ssh -o StrictHostKeyChecking=no -i "new-key-for-monitoringapp.pem" ubuntu@$input2 <<EOF
sudo apt update -y
sudo apt install docker-compose -y
cd Server$ && sudo docker-compose build
sudo docker-compose up -d
exit
EOF

echo "web portal url = http://"$input2":81"
echo "phpmyadmin url = http://"$input2":82"
echo "IP addess of server = "$input2
