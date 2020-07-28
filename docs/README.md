# Micronaut + Micronaut Data + Graal
## Before You Begin

This 2-hour lab walks you through the steps to use Micronaut, Micronaut Data
and GraalVM native image connected to an Oracle Database.
1. Create an Oracle Cloud account
1. Create an Autonomous Transaction Processing (ATP) Database
1. Create an Oracle Compute instance and install/configure  
   1. Graal

### What Do You Need?

* Internet Browser
* [GitHub](https://github.com/) Account  
   If you do not already have a GitHub account, create one now
* [Micronaut](https://micronaut.io/download.html)
* [Graal](https://github.com/graalvm/graalvm-ce-builds/releases/tag/vm-20.1.0)
* [VS Code](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjijsO-we7qAhVjMX0KHdJTCgYQFjAAegQIBRAB&url=https%3A%2F%2Fcode.visualstudio.com%2Fdownload&usg=AOvVaw11fc5fOXYIyxQh75jYLjXg) or [IntelliJ](https://www.jetbrains.com/idea/download/#section=mac)

## Part 1 - Create an Oracle Always-Free Cloud Account
1. Go to https://www.oracle.com/cloud/free/
2. Click "Start for free"
3. Populate the forms and create an account.
4. Once your account is created, [log in](https://www.oracle.com/cloud/sign-in.html) and go to the dashboard.  
   ![](images/cloudDashboard.png)

## Part 2 - Create a Compartments
 [Compartment](https://docs.cloud.oracle.com/iaas/Content/Identity/Tasks/managingcompartments.htm) are useful when you want to organize and isolate your cloud resources. Create a compartment for the objects used in this lab.
1. Click the menu icon in the upper left corner.
1. Scroll to the bottom, under Identity, click "Compartments".
   ![](images/compartmentMenu.png)
1. Click "Create Compartment".
   ![](images/compartmentCreate.png)
1. Populate the Name and Description.
1. Leave the parent compartment set to (root).
1. Click "Create Compartment"  
   ![](images/compartmentForm.png)
1. Click the "Oracle Cloud" logo to return to the dashboard.

## Part 3 - Create an ATP instance
You will need a database to complete the exercises.  An Oracle Autonomous Database handles a lot of the background admin tasks for you so you can focus on your project.
1. Click "Create an ATP database" in the Autonomous Transaction Processing box.  
   ![](images/cloudDashboard.png)
1. Choose your new compartment.
1. Enter `store` in Display name
1. Enter  `store` in Database name
1. Make sure "Transaction Processing" is selected.
1. Make sure "Shared Infrastructure" is selected.  
   ![](images/createATPForm1.png)
1. Scroll down to "Create administrator credentials".  Enter and confirm the ADMIN password.  
   **Note:**  the Admin account is the top level user for your new database.  Create a strong password and keep it secure.
1. Scroll to the bottom and click "Create Autonomous Database".  
   ![](images/createATPForm2.png)  
   You will receive an email when your new ATP Database instance has been provisioned.
1. Locate your new database's OCID and click Copy.
   ![](images/dbOcid.png)
1. While the database is provisioned click the Cloud Shell icon. This will open a preconfigured VM that you will use to access and setup your project.
   ![](images/cloudShell.png)  
1. Once Cloud Shell is running, create an environment variable for your Database OCID you copied above.
   ```
   export DB_OCID=<pasteYourOCIDhere>
   ```
   ![](images/envVarDbOcid.png)  

   The Oracle Autonomous Database uses an extra level of security in the form of a wallet containing access keys for your new Database.  

   Once your ATP Database status is Available (the yellow box turns green) you can download the wallet inside the Cloud Shell using the pre-configured [OCI-CLI](https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/cliconcepts.htm).

   You should change the password value in this command to something more secure.  
   **Note:** This password is for the .zip file, not your database.

   In your **Cloud Shell**  
   Enter the following.
   ```
   oci db autonomous-database generate-wallet --autonomous-database-id ${DB_OCID} --password Pw4ZipFile --file ~/Wallet_micronaut.zip
   ```

## Create a Compute instance
An Oracle Compute instance is a Cloud VM that you will use to install and run all of the software for the lab.  
1. Click "Create a VM instance" in the Compute box. In this lab the Compute Instance will be accessed from the Cloud Shell and a local Terminal via SSH.
   ![](images/cloudDashboard.png)
1. Populate the name or keep the default.
   ![](images/computeForm1Create.png)
1. Scroll down the the "Add SSH keys" section.
1. Select "Paste SSH keys".
1. In your **Cloud Shell**
   1. Generate a new RSA key pair.
      ```
      ssh-keygen -t rsa -N "" -b 2048 -C "cloud_shell" -f ~/.ssh/id_rsa
      ```
   1. Display the public key and copy it.
      ```
      cat ~/.ssh/id_rsa.pub
      ```
1. Press the “+ Another Key”
1. From your local Terminal
   1. Generate a new RSA key pair.
      ```
      ssh-keygen -t rsa -N "" -b 2048 -C "cloud_shell" -f ~/.ssh/id_rsa
      ```
   1. Display the public key and copy it.
      ```
      cat ~/.ssh/id_rsa.pub
      ```
1. In the **Create Compute form**, paste the public key in the SSH KEYS box.
   ![](images/computeForm2Create.png)
   If you intend to SSH into your compute instance from any other machine, you may click the "+ Another Key" button and enter the public key for that machine.  
   (you may also want to save a copy of the Cloud Shell private key '~/.ssh/id_rsa' on your local machine.)  
   **DO NOT SHARE your private key**.  This key allows access to your compute instance.
1. Click "Create".
1. Once the Compute instance is Running, locate the Public IP Address and click Copy.  
Keep this IP address handy, it will be used throughout the lab and referred to as \<YourPublicIP>.
1. In your **Cloud Shell**  
   Create an environment variable to store the IP.
   ```
   export COMPUTE_IP=<YourPublicIP>
   ```
   ![](images/saveComputeIP.png)

1. In your **Cloud Shell**  
   Use SCP to upload the wallet .zip file (downloaded earlier) to new Compute instance.
   ```
   scp Wallet_micronaut.zip opc@${COMPUTE_IP}:/home/opc/
   ```
   ![](images/scpWallet.png)

1. In your local Terminal
   Create an environment variable to store the IP.
   ```
   export COMPUTE_IP=<YourPublicIP>
   ```

1. In your local Terminal use SSH to access your Compute Instance.
   ```
   ssh opc@${COMPUTE_IP}
   ```

1. Now we need to setup the Compute Instance by installing the software needed to run this lab.

   Install Git:
   ```
   sudo yum install -y git
   git --version
   ```
   Install graal:
   ```
   wget
   https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-20.1.0/graalvm-ce-java11-linux-amd64-20.1.0.tar.gz

   tar -xf graalvm-ce-java11-linux-amd64-20.1.0.tar.gz

   rm graalvm-ce-java11-linux-amd64-20.1.0.tar.gz

   export JAVA_HOME=/home/opc/graalvm-ce-java11-20.1.0

   export PATH=$JAVA_HOME/bin:/home/opc/micronaut-cli-2.0.0/bin:$PATH

   java -version
   ```
   openjdk version "11.0.7" 2020-04-14
   OpenJDK Runtime Environment GraalVM CE 20.1.0 (build 11.0.7+10-jvmci-20.1-b02)
   OpenJDK 64-Bit Server VM GraalVM CE 20.1.0 (build 11.0.7+10-jvmci-20.1-b02, mixed mode, sharing)

   Install micronaut:
   ```
   wget https://github.com/micronaut-projects/micronaut-starter/releases/download/v2.0.0/micronaut-cli-2.0.0.zip

   unzip micronaut-cli-2.0.0.zip

   rm micronaut-cli-2.0.0.zip

   mn --version
   ```
   Micronaut Version: 2.0.0
   JVM Version: 11.0.7

1. Setup the Database Wallet
   ```
   sudo mkdir -p /opt/oracle/wallet

   sudo mv Wallet_micronaut.zip /opt/oracle/wallet/

   sudo unzip /opt/oracle/wallet/Wallet_micronaut.zip -d /opt/oracle/wallet/

   echo 'export TNS_ADMIN=/opt/oracle/wallet/' >> ~/.bashrc

   source ~/.bashrc
   ```
   Newer versions of Oracles ojdbc driver make it much easier to access a database using the extra wallet security.  To enable these features, edit the wallet/ojdbc.properties file.
   ```
   sudo nano /opt/oracle/wallet/ojdbc.properties
   ```
      1. Comment line 2
      1. Un-comment the last 4 lines that start with '#javax.net.ssl'
      1. Replace <password_from_console> with the password you used when you downloaded the wallet .zip file.
         ```
         # Connection property while using Oracle wallets.
         # oracle.net.wallet_location=(SOURCE=(METHOD=FILE)(METHOD_DATA=(DIRECTORY=${TNS_ADMIN})))
         # FOLLOW THESE STEPS FOR USING JKS
         # (1) Uncomment the following properties to use JKS.
         # (2) Comment out the oracle.net.wallet_location property above
         # (3) Set the correct password for both trustStorePassword and keyStorePassword.
         # It's the password you specified when downloading the wallet from OCI Console or the Service Console.
         javax.net.ssl.trustStore=${TNS_ADMIN}/truststore.jks
         javax.net.ssl.trustStorePassword=Pw4ZipFile
         javax.net.ssl.keyStore=${TNS_ADMIN}/keystore.jks
         javax.net.ssl.keyStorePassword=Pw4ZipFile
         ```
      1. Save the file

## Continue through the following section
1. Micronaut [Micronaut](Micronaut.md)

## Want to Learn More?
* [Oracle Cloud](http://www.oracle.com/cloud/free)
* [Oracle Live Labs](https://oracle.github.io/learning-library/developer-library/)
