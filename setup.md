# Setup

Run the setup script. 

**Note:** This script will take 5-10 minutes to run!

```shell script
wget https://raw.githubusercontent.com/recursivecodes/micronaut-data-jdbc-graal-atp/master/scripts/setup.sh
chmod +x setup.sh
./setup.sh
```

Copy the following items from the script output:

* Instance IP address
* DB Admin Password
* DB User Password
* Vault OCID
* Instance private key 

Create a file called `id_oci` containing the private key contents. This will be how you connect to the VM via SSH.

```shell script
ssh opc@[instance ip] -i /path/to/id_oci
```