# Micronaut Data JDBC Graal Autonomous DB 

Test application for Micronaut Data JDBC and GraalVM that uses Oracle Autonomous DB.

## Pre-Requesites

### Local Development Machine

1. GraalVM installed locally - https://www.graalvm.org/getting-started/#install-graalvm
2. Micronaut installed locally (SDKMAN! install recommended) https://micronaut.io/download.html
3. OCI Config file created locally at `~/.oci/config` - https://docs.cloud.oracle.com/en-us/iaas/Content/Functions/Tasks/functionsconfigureocicli.htm
4. `setup.sh` script executed on **local machine**. See: [setup.md](setup.md)

### Oracle Cloud Tenancy

1. Resource Manager stack created See: [setup.md](setup.md)

## Setup, Run, Build & Deploy

**Note:** Please read [setup.md](setup.md)!

## Native Image

TODO: Populate, if we can get it to work...

## Test

When running locally:

```
curl localhost:8080/owners
curl localhost:8080/owners/Fred

curl localhost:8080/pets
curl localhost:8080/pets/Dino
```