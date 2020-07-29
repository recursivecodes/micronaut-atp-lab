# Setup

## Create an SSH Keypair

For example:

```shell script
ssh-keygen -t rsa -N "" -b 2048 -C "id_oci" -f /path/to/id_oci
```

## Create Infrastructure

Download the latest Terraform configuration (stack.zip) from: 

https://github.com/recursivecodes/micronaut-data-jdbc-graal-atp/releases

Go to the Resource Manager:

![Create stack button](images/resource_manager_link.png)

Click 'Create Stack':

![Create stack button](images/create_stack_btn.png)

Choose 'My Configuration', and upload the configuration zip:

![Create stack button](images/stack_info_1.png)

Enter name, description and choose the compartment, then click 'Next':

![Create stack button](images/stack_info_2.png)

Accept the default data in this section:

![Create stack button](images/stack_var_1.png)

And this section:

![Create stack button](images/stack_var_2.png)

Upload your public SSH key:

![Create stack button](images/stack_var_3.png)

Accept this data. Click 'Next', review and create your stack.

![Create stack button](images/stack_var_4.png)

On the stack details page, click 'Terraform Actions' and select 'Plan'.

![Create stack button](images/stack_plan.png)

Review the plan output, ensure no failures.

![Create stack button](images/plan_log.png)

Click 'Terraform Actions' and select 'Apply'.

![Create stack button](images/stack_apply.png)

Choose the plan you just created, then click 'Apply'.

![Create stack button](images/stack_apply_2.png)

Review the output, and collect the following values from the output:

* compartment_id
* tns_name
* autonomous_database_admin_password
* autonomous_database_schema_password
* autonomous_database_wallet_password
* atp_id
* vault_id
* key_id

## Create Secrets

From Cloud Shell, download the script, make it executable, and run it:

```shell script
wget https://raw.githubusercontent.com/recursivecodes/micronaut-data-jdbc-graal-atp/master/scripts/setup.sh
chmod +x setup.sh
./setup.sh
```

Enter the values that you copied from the TF output when prompted.

