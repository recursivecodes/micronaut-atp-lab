# Setup

## Setup OCI CLI Profile On Local Machine

Follow instructions here:

https://docs.cloud.oracle.com/en-us/iaas/Content/Functions/Tasks/functionsconfigureocicli.htm

## Create an SSH Keypair

For example:

```shell script
ssh-keygen -t rsa -N "" -b 2048 -C "id_oci" -f /path/to/id_oci
```

## Create Infrastructure

Download the latest Terraform configuration (stack.zip) from: 

https://github.com/recursivecodes/micronaut-data-jdbc-graal-atp/releases/latest/download/stack.zip

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

Review the output:

![Create stack button](images/tf_output.png)

Collect the following values from the output:

* compartment_ocid
* tns_name
* atp_admin_password
* atp_schema_password
* atp_wallet_password
* atp_db_ocid
* vault_ocid
* key_ocid
* region

## Create Secrets

From Cloud Shell, download the script, make it executable, and run it:

```shell script
wget -O setup.sh https://github.com/recursivecodes/micronaut-data-jdbc-graal-atp/releases/latest/download/setup.sh
chmod +x setup.sh
./setup.sh
```

Enter the values that you copied from the TF output when prompted.

The script will produce YAML output to paste into `application.yml`. For example: 

```yaml
datasources:
  default:
    url: jdbc:oracle:thin:@mnociatp_high?TNS_ADMIN=/tmp/demo-wallet
    driverClassName: oracle.jdbc.OracleDriver
    username: mnocidemo
    password: ${MICRONAUT_OCI_DEMO_PASSWORD}
    schema-generate: CREATE_DROP
    dialect: ORACLE
```

And, output to create a file called `src/main/resources/bootstrap.yml`. For example:

```yaml
oraclecloud:
  vault:
    config:
      enabled: true
    vaults:
      - ocid: ocid...
        compartment-ocid: ocid...
    use-instance-principal: false
    path-to-config: ~/.oci/config
    profile: DEFAULT
    region: us-phoenix-1
```

And, output to create a file called `src/main/resources/bootstrap-prod.yml`. For example:

```yaml 
oraclecloud:
  vault:
    config:
      enabled: true
    vaults:
      - ocid: ocid...
        compartment-ocid: ocid...
    use-instance-principal: true
    profile: DEFAULT
    region: us-phoenix-1
```

## Deploy

TODO: finish...

When running on VM, do:
```shell script
java -jar -Dmicronaut.bootstrap.name bootstrap-prod /path/to/your.jar
```
