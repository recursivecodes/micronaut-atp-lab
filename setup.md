# Setup

Run the setup script from Cloud Shell. This script will perform the following:

* Create a compartment
* Create an SSH keypair
* Create passwords for a DB admin & DB user
* Create a virtual cloud network (VCN)
* Create a subnet in the VCN
* Update the default VCN security list to allow ingress on port 8080
* Create a VM (and allow port 8080 through the firewall)
* Create an ATP instance
* Create a schema called 'mnocidemo' on the ATP instance
* Download the ATP instance wallet
* Create a vault
* Create a key in the vault
* Create secrets with the Base64 encoded contents of each file in the wallet
* Create a secret containing the DB user password

**Note:** This script will take 5-10 minutes to run!

To run, open cloud shell and execute the following commands:

```shell script
wget https://raw.githubusercontent.com/recursivecodes/micronaut-data-jdbc-graal-atp/master/scripts/setup.sh
chmod +x setup.sh
./setup.sh
```

The script will produce output for the values you should copy to your local machine.

Copy the following items from the script output:

* Instance IP address
* DB Admin Password
* DB User Password
* Vault OCID
* Instance private key 

Create a file called `~/.ssh/id_oci` containing the private key contents. This will be how you connect to the VM via SSH.

```shell script
ssh opc@[instance ip] -i ~/.ssh/id_oci
```