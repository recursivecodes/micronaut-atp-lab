#!/bin/sh
# this script is used to generate the "user_data" in `setup.sh`
# base64 encode this file and set it in terraform/variables.tf, and whatever is in this script will be run at startup of the VM
sudo firewall-offline-cmd --zone=public --add-port=8080/tcp
sudo sh -c 'echo "Java Version Installed: `java -version`" > /etc/motd'
sudo sh -c 'echo "Welcome Micronaut HOL Attendee!" > /etc/motd'
sudo yum install -y jdk-11.0.7.x86_64
