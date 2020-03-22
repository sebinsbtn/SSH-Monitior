# Devops - SSH Monitor App

This application monitors and reports SSH login attempts to multiple servers.

The result will be saved in a mysql database and available on web console.

This project consists of two applications - Server and Client.

Source codes can be found on Server and Client directories respectively.

## Technologies Used

Bash , Python , Mysql , Docker , docker-compose , aws cli , PHP and HTML


##Installation - Server

###Prerequisites

A server machine with docker-compose installed
ports 81,82 and 1492 available publicly

###Steps

Copy the contents of Server directory to the destination sever

run the scripts
```bash
sudo docker-compose build
sudo docker-compose up -d
```
The web server will be available on http://IP:81
A phpmyadmin portal will be available on http://IP:82
A python TCP application will listen at port 1492 for incoming connections from clients.







