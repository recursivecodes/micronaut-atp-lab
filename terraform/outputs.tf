output "vcn_id" {
  description = "OCID of created VCN. "
  value       = oci_core_vcn.this.id
}

output "instance_id" {
  description = "ocid of created instances. "
  value       = [oci_core_instance.this.id]
}

output "public_ip" {
  description = "Public IPs of created instances. "
  value       = [oci_core_instance.this.public_ip]
}

output "autonomous_database_admin_password" {
  value = random_string.autonomous_database_admin_password.result
}

output "autonomous_database_schema_password" {
  value = random_string.autonomous_database_schema_password.result
}

output "autonomous_database_wallet_password" {
  value = random_string.autonomous_database_wallet_password.result
}

output "vault_id" {
  value = oci_kms_vault.this.id
}

output "key_id" {
  value = oci_kms_key.this.id
}

output "tns_name" {
  value = "${oci_database_autonomous_database.autonomous_database.db_name}_high"
}

output "atp_id" {
  value = oci_database_autonomous_database.autonomous_database.id
}

output "compartment_id" {
  value = oci_kms_vault.this.compartment_id
}
