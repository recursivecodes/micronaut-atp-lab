# collect some info
read -p "Enter 'compartment_ocid': " COMPARTMENT_ID
read -p "Enter 'tns_name' [mnociatp_high]: " TNS_NAME
TNS_NAME=${TNS_NAME:-mnociatp_high}
read -p "Enter 'atp_admin_password': " -s DB_ADMIN_PASSWORD
echo
read -p "Enter 'atp_schema_password': " -s DB_USER_PASSWORD
echo
read -p "Enter 'atp_wallet_password': " -s WALLET_PASSWORD
echo
read -p "Enter 'atp_db_ocid': " ATP_ID
read -p "Enter 'public_ip': " PUBLIC_IP
read -p "Enter 'region': " REGION

# clean up past runs
rm -rf /tmp/wallet /tmp/wallet-encoded
rm -f /tmp/id_rsa /tmp/id_rsa.pub

# download wallet
echo "Downloading wallet..."
export WALLET=$(oci db autonomous-database generate-wallet \
                --autonomous-database-id $ATP_ID \
                --file /tmp/wallet.zip \
                --password $WALLET_PASSWORD)
echo "Wallet downloaded!"

# unzip wallet
unzip /tmp/wallet.zip -d /tmp/wallet

echo "Creating schema..."
# fix the sqlnet.ora file
sed -i 's/?\/network\/admin/\/tmp\/wallet/g' /tmp/wallet/sqlnet.ora
export TNS_ADMIN=/tmp/wallet

# create schema user
echo "Creating schema 'mnocidemo' on ATP instance..."
echo "CREATE USER mnocidemo IDENTIFIED BY \"$DB_USER_PASSWORD\";" | sqlplus -s admin/$DB_ADMIN_PASSWORD@mnociatp_high
echo "GRANT CONNECT, RESOURCE TO mnocidemo;" | sqlplus -s admin/$DB_ADMIN_PASSWORD@mnociatp_high
echo "GRANT UNLIMITED TABLESPACE TO mnocidemo;" | sqlplus -s admin/$DB_ADMIN_PASSWORD@mnociatp_high
echo "Schema 'mnocidemo' created!"
echo "Updating the 'mnocidemo' schema..."
echo 'CREATE TABLE "PET" ("ID" VARCHAR(36),"OWNER_ID" NUMBER(19) NOT NULL,"NAME" VARCHAR(255) NOT NULL,"TYPE" VARCHAR(255) NOT NULL);' | sqlplus -s mnocidemo/$DB_USER_PASSWORD@mnociatp_high
echo "Table 'PET' is created!"
echo 'CREATE SEQUENCE "OWNER_SEQ" MINVALUE 1 START WITH 1 NOCACHE NOCYCLE;' | sqlplus -s mnocidemo/$DB_USER_PASSWORD@mnociatp_high
echo "Sequence 'OWNER_SEQ' is created!"
echo 'CREATE TABLE "OWNER" ("ID" NUMBER(19) PRIMARY KEY NOT NULL,"AGE" NUMBER(10) NOT NULL,"NAME" VARCHAR(255) NOT NULL);' | sqlplus -s mnocidemo/$DB_USER_PASSWORD@mnociatp_high
echo "Table 'OWNER' is created!"
echo
echo "Step 1: Download your wallet to your local machine (see instructions):"
echo
echo "Step 2: Run your app (locally) with:"
echo
echo "export TNS_ADMIN=/tmp/wallet"
echo "export DATASOURCES_DEFAULT_PASSWORD=${DB_USER_PASSWORD}"
echo "./gradlew run -t"
echo
echo "Step 3: Upload your zip (one time, from local machine to VM) with:"
echo
echo "scp -i ~/.ssh/id_rsa -r /tmp/wallet opc@${PUBLIC_IP}:/tmp/wallet"
echo
echo "Step 4: Deploy your JAR (from local machine to VM) with:"
echo
echo "scp -i ~/.ssh/id_rsa -r build/libs/example-atp-0.1-all.jar opc@${PUBLIC_IP}:/app/application.jar"
echo
echo "Step 5: SSH into your VM"
echo
echo "ssh -i ~/.ssh/id_rsa opc@${PUBLIC_IP}"
echo
echo "Step 6: Run your JAR on the VM with:"
echo
echo "export DATASOURCES_DEFAULT_PASSWORD=${DB_USER_PASSWORD}"
echo "export TNS_ADMIN=/tmp/wallet"
echo "java -jar /app/application.jar"
echo
echo "Done!"

## Clean Up
rm -rf /tmp/wallet /tmp/wallet-encoded