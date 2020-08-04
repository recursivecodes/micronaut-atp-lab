#!/bin/sh
# this script is used to generate the "user_data" in `setup.sh`
# base64 encode this file and set it in terraform/variables.tf, and whatever is in this script will be run at startup of the VM
echo "***making /java directory***"
mkdir -p /java
echo "***downloading graalvm***"
wget -q -O /java/graalvm-ce-java11-linux-amd64-20.1.0.tar.gz https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-20.1.0/graalvm-ce-java11-linux-amd64-20.1.0.tar.gz
echo "***unzipping graalvm***"
tar -xf /java/graalvm-ce-java11-linux-amd64-20.1.0.tar.gz -C /java/
echo "***removing zip***"
rm /java/graalvm-ce-java11-linux-amd64-20.1.0.tar.gz
echo "***setting JAVA_HOME***"
echo "export JAVA_HOME=/java/graalvm-ce-java11-20.1.0" >> /etc/profile.d/java.sh
echo "***setting PATH***"
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile.d/java.sh
echo "***setting firewall rules***"
sudo firewall-offline-cmd --zone=public --add-port=8080/tcp
sudo systemctl restart firewalld
echo "***setting motd***"
sudo sh -c 'echo "Welcome Micronaut Hands On Lab Attendee!" > /etc/motd'
echo "setup done!"