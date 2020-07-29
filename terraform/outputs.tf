output "vcn_id" {
  description = "OCID of created VCN. "
  value       = oci_core_vcn.this.id
}

output "default_security_list_id" {
  description = "OCID of default security list. "
  value       = oci_core_vcn.this.default_security_list_id
}

output "default_dhcp_options_id" {
  description = "OCID of default DHCP options. "
  value       = oci_core_vcn.this.default_dhcp_options_id
}

output "default_route_table_id" {
  description = "OCID of default route table. "
  value       = oci_core_vcn.this.default_route_table_id
}

output "internet_gateway_id" {
  description = "OCID of internet gateway. "
  value       = oci_core_internet_gateway.this.id
}

output "subnet_ids" {
  description = "ocid of subnet ids. "
  value       = oci_core_subnet.this.*.id
}

output "instance_id" {
  description = "ocid of created instances. "
  value       = [oci_core_instance.this.id]
}

output "private_ip" {
  description = "Private IPs of created instances. "
  value       = [oci_core_instance.this.private_ip]
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

output "autonomous_database_high_connection_string" {
  value = lookup(oci_database_autonomous_database.autonomous_database.connection_strings.0.all_connection_strings, "high", "unavailable")
}

output "autonomous_databases" {
  value = data.oci_database_autonomous_databases.autonomous_databases.autonomous_databases
}

output "autonomous_database_wallet_password" {
  value = random_string.autonomous_database_wallet_password.result
}

output "security_list" {
  value = oci_core_security_list.this
}

output "vault" {
  value = oci_kms_vault.this
}

output "key" {
  value = oci_kms_key.this
}

output "tns_name" {
  value = "${oci_database_autonomous_database.autonomous_database.db_name}_high"
}

output "atp_id" {
  value = oci_database_autonomous_database.autonomous_database.id
}
