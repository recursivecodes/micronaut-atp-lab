variable "compartment_ocid" {}
variable "tenancy_ocid" {}
variable "region" {}

variable "instance_display_name" {
  default = "mn-oci-demo"
}
variable "boot_volume_size_in_gbs" {
  default = 50
}
variable "shape" {
  default = "VM.Standard.E2.1.Micro"
}
variable "assign_public_ip" {
  default = "true"
}
variable "vnic_name" {
  default = "vnic"
}
variable "ssh_public_key" {}

variable "user_data" {
  default = "IyEvYmluL3NoCiMgdGhpcyBzY3JpcHQgaXMgdXNlZCB0byBnZW5lcmF0ZSB0aGUgInVzZXJfZGF0YSIgaW4gYHNldHVwLnNoYAojIGJhc2U2NCBlbmNvZGUgdGhpcyBmaWxlIGFuZCBzZXQgaXQgaW4gdGVycmFmb3JtL3ZhcmlhYmxlcy50ZiwgYW5kIHdoYXRldmVyIGlzIGluIHRoaXMgc2NyaXB0IHdpbGwgYmUgcnVuIGF0IHN0YXJ0dXAgb2YgdGhlIFZNCnN1ZG8gZmlyZXdhbGwtb2ZmbGluZS1jbWQgLS16b25lPXB1YmxpYyAtLWFkZC1wb3J0PTgwODAvdGNwCnN1ZG8geXVtIGluc3RhbGwgLXkgamRrLTExLjAuNy54ODZfNjQKc3VkbyBzaCAtYyAnZWNobyAiV2VsY29tZSBNaWNyb25hdXQgSE9MIEF0dGVuZGVlISIgPiAvZXRjL21vdGQnCg=="
}

variable "block_storage_size_in_gbs" {
  default = 50
}
variable "vcn_display_name" {
  default = "testVCN"
}

variable "attachment_type" {
  default = "iscsi"
}

variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "vcn_dns_label" {
  default     = "vcn"
}

variable "subnet_dns_label" {
  default = "subnet"
}

variable "autonomous_database_db_workload" {
  default = "OLTP"
}

variable "autonomous_database_license_model" {
  default = "LICENSE_INCLUDED"
}

variable "autonomous_database_db_name" {
  default = "mnociatp"
}

variable "autonomous_database_display_name" {
  default = "mnociatp"
}

variable "autonomous_database_is_dedicated" {
  default = "false"
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  region           = var.region
}
