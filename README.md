# Devops - SSH Monitor App

This application monitors and reports SSH login attempts to multiple servers.

The result will be saved in a mysql database and available on web console.

This project consists of two applications - Server and Client.

Source codes can be found on Server and Client directories respectively.

## Technologies Used

Bash , Python , Mysql , Docker , docker-compose , aws cli , PHP and HTML


## Installation - Server

### Prerequisites

A server machine with docker-compose installed
ports 81,82 and 1492 available publicly

### Steps

Copy the contents of Server directory to the destination server

run the scripts
```bash
sudo docker-compose build
sudo docker-compose up -d
```
The web server will be available on http://IP:81
A phpmyadmin portal will be available on http://IP:82
A python TCP application will listen at port 1492 for incoming connections from clients.

## Complete Demo with AWS ec2

The complete setup for server including server creation, adding security groups, installation etc is included in the aws.sh file
Currently supports us-east-1 region only

### Prerequisites

Linux machine with AWS CLI installed

An AWS access key and secret key (Having Ec2, VPC access)

An AWS Ubuntu AMI Id

### Steps

Clone this repository to the linux machine

Configure aws with or without a profile
```bash
aws configure
or
aws configure --profile demporofile
```
choose default region as us-east-1

Run the script aws.sh with profile name as command line argument - if not provided it will take default profile

```bash
./aws.sh demporofile
```
Script will ask to input AMI Id - provide an Ubuntu AMI ID in us-east-1 region

After running the script, the created server IP, web and phpmyadmin url will be avilable as console output


## Installation - Client

### Prerequisites

A linux client machine 
ssh access and internet access on the machine (if server is not in the same network)

### Steps

Copy client.sh file from CLient directory to the destination server

Open the client.sh file and REPLACE the IP address field by the IP of the previously set up server

run the scripts
```bash
sudo ./client.sh
```
From next ssh login onwards, the results will be available on server web portal

This deployment is idempotent - Multiple runs of this script will provide the same state of the node

## Complete Demo with AWS ec2

The complete setup for server including server creation, adding security groups, installation etc is included in the deploy-client-aws.sh file
Currently supports us-east-1 region only

### Prerequisites

Linux machine with AWS CLI installed

An AWS access key and secret key (Having Ec2, VPC access)

An AWS Ubuntu AMI Id

### Steps

Clone this repository to the linux machine

Configure aws with or without a profile
```bash
aws configure
or
aws configure --profile demporofile
```
choose default region as us-east-1

Run the script aws.sh with profile name as command line argument - if not provided it will take default profile

```bash
./deploy-client-aws.sh demporofile
```
Script will ask to input AMI Id - provide an Ubuntu AMI ID in us-east-1 region

After running the script, the created server IP will be avilable as console output

## Installation - Client as EC2 Bootstrap

Open the client.sh file and REPLACE the IP address field by the IP of the previously set up server.
Add the client.sh script as user data when creating an ec2 linux instance

From next login onwards, results will be available on the web console








