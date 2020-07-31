# Micronaut Data JDBC Graal Autonomous DB 

Test application for Micronaut Data JDBC and GraalVM that uses Oracle Autonomous DB.

## Pre-Requesites

1. Java 8+ installed
2. Micronaut installed
3. OCI Config file created at `~/.oci/config` per https://docs.cloud.oracle.com/en-us/iaas/Content/Functions/Tasks/functionsconfigureocicli.htm
4. Resource Manager stack created See: [setup.md](setup.md)
5. `setup.sh` script executed on **local machine**. See: [setup.md](setup.md)

## Setup

**Note:** Please read [setup.md](setup.md)!

## Run

Run the app with the snippet provided from the output of `setup.sh`

Should result in similar output:

```shell script
```

## Build

With:

```shell script
$ ./gradlew assemble
```

Run the JAR with:

```shell script
```

## Native Image

TODO: Populate, if we can get it to work...

## Deploy

TODO: Are we going to deploy?

## Test

When running locally:

```
curl localhost:8080/owners
curl localhost:8080/owners/Fred

curl localhost:8080/pets
curl localhost:8080/pets/Dino
```
