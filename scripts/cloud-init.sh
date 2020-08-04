#!/bin/sh
# this script is used to generate the "user_data" in `setup.sh`
# base64 encode this file and set it in terraform/variables.tf, and whatever is in this script will be run at startup of the VM
echo "setting firewall rules..."
sudo firewall-offline-cmd --zone=public --add-port=8080/tcp
echo "downloading graalvm..."
wget -q -O /home/opc/graalvm-ce-java11-linux-amd64-20.1.0.tar.gz https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-20.1.0/graalvm-ce-java11-linux-amd64-20.1.0.tar.gz
echo "unzipping graalvm..."
tar -xf /home/opc/graalvm-ce-java11-linux-amd64-20.1.0.tar.gz
echo "removing zip..."
rm /home/opc/graalvm-ce-java11-linux-amd64-20.1.0.tar.gz
echo "setting JAVA_HOME..."
export JAVA_HOME=/home/opc/graalvm-ce-java11-20.1.0
echo "setting PATH..."
export PATH=$JAVA_HOME/bin:$PATH
echo "setting motd..."
sudo sh -c 'echo "Welcome Micronaut HOL Attendee!" > /etc/motd'
echo "setup done."