# collect some info
read -p -n "Enter 'compartment_ocid': " COMPARTMENT_ID
read -p -n "Enter 'tns_name' [mnociatp_high]: " TNS_NAME
TNS_NAME=${TNS_NAME:-mnociatp_high}
read -p -n "Enter 'atp_admin_password': " -s DB_ADMIN_PASSWORD
echo
read -p -n "Enter 'atp_schema_password': " -s DB_USER_PASSWORD
echo
read -p -n "Enter 'atp_wallet_password': " -s WALLET_PASSWORD
echo
read -p -n "Enter 'atp_db_ocid': " ATP_ID
read -p -n "Enter 'vault_ocid': " VAULT_ID
read -p -n "Enter 'key_ocid': " KEY_ID
read -p -n "Enter 'region': " REGION

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

# b64 wallet
echo "Encoding wallet contents..."
echo "Creating /tmp/wallet-encoded..."
mkdir /tmp/wallet-encoded
echo Looping files in /tmp/wallet...
for f in /tmp/wallet/*
 do
   fname=$(basename $f)
   echo "Writing /tmp/wallet-encoded/$fname"
   base64 -i $f > /tmp/wallet-encoded/$fname
 done
echo "Wallet contents encoded!"

# create secrets
echo "Creating secrets in vault..."

# Create secret for /tmp/wallet-encoded/cwallet.sso (CWALLET_SSO)
echo "Creating CWALLET_SSO secret..."
export SECRET_CWALLET_SSO=$(oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name WALLET_CWALLET_SSO \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(cat /tmp/wallet-encoded/cwallet.sso)")

# Create secret for /tmp/wallet-encoded/ewallet.p12 (EWALLET_P12)
export SECRET_EWALLET_P12=$(echo "Creating EWALLET_P12 secret..."
oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name WALLET_EWALLET_P12 \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(cat /tmp/wallet-encoded/ewallet.p12)")

# Create secret for /tmp/wallet-encoded/keystore.jks (KEYSTORE_JKS)
echo "Creating KEYSTORE_JKS secret..."
export SECRET_KEYSTORE_JKS=$(oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name WALLET_KEYSTORE_JKS \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(cat /tmp/wallet-encoded/keystore.jks)")

# Create secret for /tmp/wallet-encoded/ojdbc.properties (OJDBC_PROPERTIES)
echo "Creating OJDBC_PROPERTIES secret..."
export SECRET_OJDBC_PROPERTIES=$(oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name WALLET_OJDBC_PROPERTIES \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(cat /tmp/wallet-encoded/ojdbc.properties)")

# Create secret for /tmp/wallet-encoded/sqlnet.ora (SQLNET_ORA)
echo "Creating SQLNET_ORA secret..."
export SECRET_SQLNET_ORA=$(oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name WALLET_SQLNET_ORA \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(cat /tmp/wallet-encoded/sqlnet.ora)")

# Create secret for /tmp/wallet-encoded/tnsnames.ora (TNSNAMES_ORA)
echo "Creating TNSNAMES_ORA secret..."
export SECRET_TNSNAMES_ORA=$(oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name WALLET_TNSNAMES_ORA \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(cat /tmp/wallet-encoded/tnsnames.ora)")

# Create secret for /tmp/wallet-encoded/truststore.jks (TRUSTSTORE_JKS)
echo "Creating TRUSTSTORE_JKS secret..."
export SECRET_TRUSTSTORE_JKS=$(oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name WALLET_TRUSTSTORE_JKS \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(cat /tmp/wallet-encoded/truststore.jks)")

# Create secret for DB Password (MICRONAUT_OCI_DEMO_PASSWORD)
echo "Creating MICRONAUT_OCI_DEMO_PASSWORD secret..."
export SECRET_MICRONAUT_OCI_DEMO_PASSWORD=$(oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name MICRONAUT_OCI_DEMO_PASSWORD \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(echo $DB_USER_PASSWORD | base64)")

echo "Secrets created!"
echo "All secrets have been created!"

echo 'Paste this into your src/main/resources/application.yml:'

echo "datasources:"
echo "  default:"
echo "    url: jdbc:oracle:thin:@${TNS_NAME}?TNS_ADMIN=/tmp/demo-wallet"
echo "    driverClassName: oracle.jdbc.OracleDriver"
echo "    username: mnocidemo"
echo "    password: \${MICRONAUT_OCI_DEMO_PASSWORD}"
echo "    schema-generate: CREATE_DROP"
echo "    dialect: ORACLE"

echo 'Paste this into your src/main/resources/bootstrap.yml:'

echo "oraclecloud:"
echo "  vault:"
echo "    config:"
echo "      enabled: true"
echo "    vaults:"
echo "      - ocid: ${VAULT_ID}"
echo "        compartment-ocid: ${COMPARTMENT_ID}"
echo "    use-instance-principal: false"
echo "    path-to-config: ~/.oci/config"
echo "    profile: DEFAULT"
echo "    region: ${REGION}"

echo 'Paste this into your src/main/resources/bootstrap-prod.yml:'

echo "oraclecloud:"
echo "  vault:"
echo "    config:"
echo "      enabled: true"
echo "    vaults:"
echo "      - ocid: ${VAULT_ID}"
echo "        compartment-ocid: ${COMPARTMENT_ID}"
echo "    use-instance-principal: true"
echo "    profile: DEFAULT"
echo "    region: ${REGION}"

# clean up files
rm -rf /tmp/wallet /tmp/wallet-encoded
rm -f /tmp/id_oci /tmp/id_oci.pub

