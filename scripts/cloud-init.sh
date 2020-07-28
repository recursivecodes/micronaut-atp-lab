#!/bin/sh
# this script is used to generate the "user_data" in `setup.sh`
# just base64 encode this file, and whatever is in this script will be run at startup of the VM
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --reload
sudo sh -c 'echo "Welcome Micronaut HOL Attendee!" > /etc/motd'