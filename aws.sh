#!/bin/bash
# rm createec2.log instanceid instanceid.first instanceid.second  ipaddress ipaddress.first  ipaddress.second  ipaddress.third image-id.out subnet-id.out securitygrp.out
# echo "Creating instance"

# aws ec2 describe-images --filters "Name=name,Values=Ubuntu Server 18.04 LTS (HVM)*" --query 'sort_by(Images, &CreationDate)[-1].[ImageId]' --output text --profile gojek >> image-id.out

# imageid=`cat image-id.out`
# echo $imageid
# imageid='ami-07ebfd5b3428b6f4d'

# aws ec2 create-key-pair --key-name new-key-for-monitoringapp --query 'KeyMaterial' --output text > new-key-for-monitoringapp.pem --profile gojek
# chmod 400 new-key-for-monitoringapp.pem

# aws ec2 describe-subnets --max-items 1 --profile gojek |grep subnet- |cut -f2- -d: |tail -n +2 | sed 's/\"//' | sed 's/\,//' |sed 's/\"//' |sed 's/\ //' >> subnet-id.out
# subnetid=`cat subnet-id.out`

# aws ec2 run-instances --image-id $imageid --key-name new-key-for-monitoringapp --instance-type t2.micro --placement AvailabilityZone=us-east-1b  --count 1 --associate-public-ip-address --subnet-id $subnetid--profile gojek --region us-east-1 >> createec2.log
# echo "Instance Created"

# sleep 3m

# cat createec2.log |grep "InstanceId" >> instanceid.first
# cat instanceid.first |cut -f2- -d: >> instanceid.second
# cat instanceid.second |sed 's/ //' | sed 's/\"//' | sed 's/\"//' | sed 's/\,//' >>instanceid

# echo "Waiting for instanceId"
# sleep 3s

# input=`cat instanceid`
# echo $input
# echo "Got instanceId"

# echo "Waiting for ip address"
# aws ec2 describe-instances --instance-ids $input --profile gojek --region us-east-1 >>ipaddress.first
# aws ec2 create-security-group --group-name monitoringappsg --description "Security group for monitoring app" --output text --profile gojek >>securitygrp.out

# aws ec2 authorize-security-group-ingress --group-name monitoringappsg --protocol tcp --port 22 --cidr 0.0.0.0/0 --profile gojek
# aws ec2 authorize-security-group-ingress --group-name monitoringappsg --protocol tcp --port 80 --cidr 0.0.0.0/0 --profile gojek
# aws ec2 authorize-security-group-ingress --group-name monitoringappsg --protocol tcp --port 81 --cidr 0.0.0.0/0 --profile gojek
# aws ec2 authorize-security-group-ingress --group-name monitoringappsg --protocol tcp --port 82 --cidr 0.0.0.0/0 --profile gojek
# aws ec2 authorize-security-group-ingress --group-name monitoringappsg --protocol tcp --port 1492 --cidr 0.0.0.0/0 --profile gojek

# securitygrp=`cat securitygrp.out`

# aws ec2 modify-instance-attribute --instance-id $input --groups $securitygrp --profile gojek --region us-east-1

# sleep 3s

cat ipaddress.first | grep "PublicIpAddress" >>ipaddress.second

cat ipaddress.second |cut -f2- -d: >> ipaddress.third

cat ipaddress.third | sed 's/_//' | sed 's/-//' | sed 's/\"//' | sed 's/\"//' | sed 's/\,//' | sed 's/\ //' >> ipaddress

input2=`cat ipaddress`
echo $input2
echo "Got IP Address"
sleep 3s


# rsync -avz -e "ssh -o StrictHostKeyChecking=no -i "new-key-for-monitoringapp.pem" -v" --delete --rsync-path="sudo rsync" Server/ ubuntu@$input2:/home/ubuntu/Server$

# echo "Copied Files"
# sleep 3s

# ssh -o StrictHostKeyChecking=no -i "new-key-for-monitoringapp.pem" ubuntu@$input2 <<EOF
# sudo apt update -y
# sudo apt install docker-compose -y
# cd Server$ && sudo docker-compose build
# sudo docker-compose up -d
# exit
# EOF

echo "web portal url = http://"$input2":81"
echo "phpmyadmin url = http://"$input2":82"
echo "IP addess of derver = "$input2
# aws ec2 terminate-instances --instance-ids $input --profile gojek --region us-east-1
