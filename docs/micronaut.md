# Micronaut + Micronaut Data + Graal

## Before You Begin

This 2-hour lab walks you through the steps to use Micronaut, Micronaut Data
and GraalVM native image to connected to an Oracle Database. Everything in this
lab runs in the cloud so nothing needs to be installed on your local machine.

1. Create an Oracle Cloud account
1. Create an Autonomous Transaction Processing (ATP) Database
1. Create an Oracle Compute instance and setup/configure
1. Build an app with Micronaut, Micronaut Data and GraalVM
1. Run your app in the cloud

## Part 1 - Cloning the code for this lab

1. Clone the repository.

   ```
   git clone https://github.com/recursivecodes/micronaut-data-jdbc-graal-atp
   ```

1. Build the repository.

   ```
   cd micronaut-data-jdbc-graal-atp

   ./gradlew assemble
   ```

1. Run the app.

   ```
   java -jar -DMICRONAUT_OCI_DEMO_PASSWORD [your generated password] /app/micronaut-data-jdbc-graal-atp-0.1-all.jar
   ```

## Continue through the following section

1. Micronaut [Micronaut](micronaut.md)

## Want to Learn More?

* [Oracle Cloud](http://www.oracle.com/cloud/free)
* [Oracle Live Labs](https://oracle.github.io/learning-library/developer-library/)
