export TENANCY_ID=$(curl http://169.254.169.254/opc/v1/instance/ | jq '.freeformTags["user-tenancy-ocid"]' --raw-output)
echo "Creating compartment..."
export COMPARTMENT=$(oci iam compartment create --compartment-id $TENANCY_ID --freeform-tags '{"project":"mn-oci-hol"}' --description "A compartment for mn-oci-demo resources" --name mn-oci-demo-compartment-$(date +%s))
export COMPARTMENT_ID=$(echo $COMPARTMENT | jq '.data.id' --raw-output)

echo "Checking compartment state..."
# manually wait for compartment to be active because compartment "wait-for-state" does not work properly
compartmentState() {
  STATE=$(oci iam compartment get -c $COMPARTMENT_ID | jq '.data["lifecycle-state"]' --raw-output)
  if [ "$STATE" = "ACTIVE" ]
  then
    return 1
  else
    return 0
  fi
}
while compartmentState
do
  echo "Checking if compartment is active..."
  sleep 5
done

# create SSH keypair for compute instance
rm -f /tmp/id_oci /tmp/id_oci.pub

echo "Generating SSH Key..."
ssh-keygen -t rsa -N "" -b 2048 -C "id_oci" -f /tmp/id_oci

echo "Generating DB password..."
export DB_ADMIN_PASSWORD=$(openssl rand -base64 12)1aA
export DB_USER_PASSWORD=$(openssl rand -base64 12)1aA
export WALLET_PASSWORD=$(openssl rand -base64 12)1aA

echo "Creating Virtual Cloud Network..."
export VCN=$(oci network vcn create \
            --cidr-block 10.0.0.0/16 \
            --freeform-tags '{"project":"mn-oci-hol"}' \
            --compartment-id $COMPARTMENT_ID \
            --wait-for-state AVAILABLE
        )
echo "Virtual Cloud Network created!"
export VCN_ID=$(echo $VCN | jq '.data.id' --raw-output)

echo "Creating Subnet..."
export SUBNET=$(oci network subnet create \
            --cidr-block 10.0.1.0/24 \
            --compartment-id $COMPARTMENT_ID \
            --freeform-tags '{"project":"mn-oci-hol"}' \
            --vcn-id $VCN_ID \
            --wait-for-state AVAILABLE
        )
echo "Subnet created!"
export SUBNET_ID=$(echo $SUBNET | jq '.data.id' --raw-output)
export SECURITY_LIST_ID=$(echo $SUBNET | jq '.data["security-list-ids"][0]' --raw-output)

echo "Updating security list..."
export SECURITY_LIST=$(oci network security-list get --security-list-id $SECURITY_LIST_ID)
# https://docs.cloud.oracle.com/en-us/iaas/api/#/en/iaas/20160918/datatypes/IngressSecurityRule
export INGRESS_RULES=$(echo $SECURITY_LIST | jq '.data["ingress-security-rules"]')
export NEW_INGRESS_RULES=$(echo $INGRESS_RULES | jq '. += [{"description":"Allow port 8080","icmpOptions":{"code":0,"type":0},"isStateless":false,"protocol":"6","source":"0.0.0.0/0","sourceType":"CIDR_BLOCK","tcpOptions":{"destinationPortRange":{"max":8080,"min":8080}}}]')
export SECURITY_LIST=$(oci network security-list update \
                      --security-list-id $SECURITY_LIST_ID \
                      --ingress-security-rules "$NEW_INGRESS_RULES" \
                      --freeform-tags '{"project":"mn-oci-hol"}' \
                      --force \
                      --wait-for-state AVAILABLE)
echo "Security list updated..."

export AVAILABILITY_DOMAIN=$(oci iam availability-domain list --query 'data[0].name' --raw-output)

# hardcoded - this is the 'developer image' that comes with Java, etc...
export CUSTOM_IMAGE_OCID=ocid1.image.oc1..aaaaaaaa2es7kqqgmmjyymzdaaeqmmehrprg6gdjxs4on5lpzwiv64przksa

# which shape?

# free-tier shape
# export SHAPE=VM.Standard.E2.1.Micro

# not free-tier eligible
export SHAPE=VM.Standard2.1

echo "Creating VM instance..."
export INSTANCE=$(oci compute instance launch \
                  --compartment-id $COMPARTMENT_ID \
                  --availability-domain $AVAILABILITY_DOMAIN \
                  --shape $SHAPE \
                  --assign-public-ip true \
                  --display-name mn-oci-demo-instance \
                  --image-id $CUSTOM_IMAGE_OCID \
                  --metadata '{"user_data": "IyEvYmluL3NoCnN1ZG8gZmlyZXdhbGwtY21kIC0tcGVybWFuZW50IC0tem9uZT1wdWJsaWMgLS1hZGQtcG9ydD04MDgwL3RjcApzdWRvIGZpcmV3YWxsLWNtZCAtLXJlbG9hZApzdWRvIHNoIC1jICdlY2hvICJXZWxjb21lIE1pY3JvbmF1dCBIT0wgQXR0ZW5kZWUhIiA+IC9ldGMvbW90ZCcK"}' \
                  --ssh-authorized-keys-file /tmp/id_oci.pub \
                  --subnet-id $SUBNET_ID \
                  --freeform-tags '{"project":"mn-oci-hol"}' \
                  --wait-for-state RUNNING)

echo "Instance created!"
export INSTANCE_ID=$(echo $INSTANCE | jq ".data.id" --raw-output)

echo "Retrieving Instance IP Address..."
export PUBLIC_IP=$(oci compute instance list-vnics --instance-id $INSTANCE_ID --query 'data[0].["public-ip"][0]' --raw-output)
echo "Instance IP Address retrieved..."

# create ATP instance
echo "Creating ATP instance..."
export ATP=$(oci db autonomous-database create \
              --admin-password $DB_ADMIN_PASSWORD \
              --compartment-id $COMPARTMENT_ID \
              --is-free-tier true \
              --cpu-core-count 1 \
              --data-storage-size-in-tbs 1 \
              --db-name mnociatp \
              --display-name mnociatp \
              --freeform-tags '{"project":"mn-oci-hol"}' \
              --wait-for-state AVAILABLE)

echo "ATP instance created!"
export ATP_ID=$(echo $ATP | jq '.data.id' --raw-output)
export TNS_NAME="mnociatp_high"

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
echo "Creating schema `mnocidemo` on ATP instance..."
echo "CREATE USER mnocidemo IDENTIFIED BY \"$DB_USER_PASSWORD\";" | sqlplus -s admin/$DB_ADMIN_PASSWORD@mnociatp_high
echo "GRANT CONNECT, RESOURCE TO mnocidemo;" | sqlplus -s admin/$DB_ADMIN_PASSWORD@mnociatp_high
echo "GRANT UNLIMITED TABLESPACE TO mnocidemo;" | sqlplus -s admin/$DB_ADMIN_PASSWORD@mnociatp_high
echo "Schema `mnocidemo` created!"

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

# create vault
echo "Creating vault..."
export VAULT=$(oci kms management vault create \
                --compartment-id $COMPARTMENT_ID \
                --display-name mn-oci-vault \
                --vault-type DEFAULT \
                --freeform-tags '{"project":"mn-oci-hol"}' \
                --wait-for-state ACTIVE)
echo "Vault created!"
export VAULT_ID=$(echo $VAULT | jq '.data.id' --raw-output)
export MANAGEMENT_ENDPOINT=$(echo $VAULT | jq '.data["management-endpoint"]' --raw-output)

# create key
echo "Creating key..."
export KEY=$(oci kms management key create \
                --compartment-id $COMPARTMENT_ID \
                --display-name mn-oci-key \
                --freeform-tags '{"project":"mn-oci-hol"}' \
                --key-shape '{"algorithm": "AES", "length": 32}' \
                --endpoint $MANAGEMENT_ENDPOINT \
                --wait-for-state ENABLED)
echo "Key created!"
export KEY_ID=$(echo $KEY | jq '.data.id' --raw-output)

# create secrets
echo "Creating secrets in vault..."

# Create secret for /tmp/wallet-encoded/cwallet.sso (CWALLET_SSO)
echo "Creating CWALLET_SSO secret..."
oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name CWALLET_SSO \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(cat /tmp/wallet-encoded/cwallet.sso)"

# Create secret for /tmp/wallet-encoded/ewallet.p12 (EWALLET_P12)
echo "Creating EWALLET_P12 secret..."
oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name EWALLET_P12 \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(cat /tmp/wallet-encoded/ewallet.p12)"

# Create secret for /tmp/wallet-encoded/keystore.jks (KEYSTORE_JKS)
echo "Creating KEYSTORE_JKS secret..."
oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name KEYSTORE_JKS \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(cat /tmp/wallet-encoded/keystore.jks)"

# Create secret for /tmp/wallet-encoded/ojdbc.properties (OJDBC_PROPERTIES)
echo "Creating OJDBC_PROPERTIES secret..."
oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name OJDBC_PROPERTIES \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(cat /tmp/wallet-encoded/ojdbc.properties)"

# Create secret for /tmp/wallet-encoded/sqlnet.ora (SQLNET_ORA)
echo "Creating SQLNET_ORA secret..."
oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name SQLNET_ORA \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(cat /tmp/wallet-encoded/sqlnet.ora)"

# Create secret for /tmp/wallet-encoded/tnsnames.ora (TNSNAMES_ORA)
echo "Creating TNSNAMES_ORA secret..."
oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name TNSNAMES_ORA \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(cat /tmp/wallet-encoded/tnsnames.ora)"

# Create secret for /tmp/wallet-encoded/truststore.jks (TRUSTSTORE_JKS)
echo "Creating TRUSTSTORE_JKS secret..."
oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name TRUSTSTORE_JKS \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(cat /tmp/wallet-encoded/truststore.jks)"

# Create secret for DB Password (MICRONAUT_OCI_DEMO_PASSWORD)
echo "Creating MICRONAUT_OCI_DEMO_PASSWORD secret..."
oci vault secret create-base64 \
  --compartment-id $COMPARTMENT_ID \
  --secret-name MICRONAUT_OCI_DEMO_PASSWORD \
  --vault-id $VAULT_ID \
  --key-id $KEY_ID \
  --wait-for-state ACTIVE \
  --freeform-tags '{"project":"mn-oci-hol"}' \
  --secret-content-content "$(echo $DB_ADMIN_PASSWORD | base64)"

echo "Secrets created!"

echo "Here is your TNS Name:"
echo $TNS_NAME
echo "-------------------------------------------"
echo "Here is your instance's public IP address:"
echo $PUBLIC_IP
echo "-------------------------------------------"
echo "Here is your vault ID:"
echo $VAULT_ID
echo "-------------------------------------------"
echo "Here is your ATP admin password:"
echo $DB_ADMIN_PASSWORD
echo "-------------------------------------------"
echo "Here is your ATP schema user password:"
echo $DB_USER_PASSWORD
echo "-------------------------------------------"
echo "Here is your private key to connect to your compute instance. Save this to your local machine as `~/.ssh/id_oci`"
cat /tmp/id_oci

echo "Script complete."
echo "All resources have been created."
echo "Scroll up to view outputs and copy this"
echo "info as it will not be shown again."

echo "After you have saved the private key to `~/.ssh/id_oci`, connect to your VM with:"
echo "ssh opc@$PUBLIC_IP -i ~/.ssh/id_oci"