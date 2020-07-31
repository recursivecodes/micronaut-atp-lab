# Micronaut Data JDBC Graal Autonomous DB 

Test application for Micronaut Data JDBC and GraalVM that uses Oracle Autonomous DB.

## Pre-Requesites

1. Java 8+ installed
2. Micronaut installed
3. OCI Config file created at `~/.oci/config` per https://docs.cloud.oracle.com/en-us/iaas/Content/Functions/Tasks/functionsconfigureocicli.htm
4. Resource Manager stack created See: [setup.md](setup.md)
5. `setup.sh` script executed on **local machine**. See: [setup.md](setup.md)

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