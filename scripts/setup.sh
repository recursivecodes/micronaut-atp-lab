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
rm -f /tmp/id_oci /tmp/id_oci.pub

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
echo
echo "Step 1: Run the following (locally) to download your wallet:"
echo
echo "oci db autonomous-database generate-wallet --autonomous-database-id $ATP_ID --file /tmp/wallet.zip --password $WALLET_PASSWORD && unzip /tmp/wallet.zip -d /tmp/wallet"
echo
echo "Step 2: Run your app (locally) with:"
echo
echo "./gradlew -DMICRONAUT_OCI_DEMO_PASSWORD=${DB_USER_PASSWORD} run"
echo
echo "Step 3: Upload your zip (one time, from local machine to VM) with:"
echo
echo "scp -i ~/.ssh/id_oci -r /tmp/wallet opc@${PUBLIC_IP}:/tmp/wallet"
echo
echo "Step 4: Deploy your JAR (from local machine to VM) with:"
echo
echo "scp -i ~/.ssh/id_oci -r build/libs/micronaut-data-jdbc-graal-atp-0.1-all.jar opc@${PUBLIC_IP}:/app"
echo
echo "Step 5: SSH into your VM"
echo
echo "ssh -i ~/.ssh/id_oci opc@${PUBLIC_IP}"
echo
echo "Step 6: Run your JAR on the VM with:"
echo
echo "java -jar -DMICRONAUT_OCI_DEMO_PASSWORD=${DB_USER_PASSWORD} /app/micronaut-data-jdbc-graal-atp-0.1-all.jar"
echo
echo "Done!"

## Clean Up
rm -rf /tmp/wallet /tmp/wallet-encoded