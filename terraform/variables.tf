variable "tenancy_ocid" {}
variable "compartment_ocid" {}
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
  default = "IyEvYmluL3NoCiMgdGhpcyBzY3JpcHQgaXMgdXNlZCB0byBnZW5lcmF0ZSB0aGUgInVzZXJfZGF0YSIgaW4gYHNldHVwLnNoYAojIGJhc2U2NCBlbmNvZGUgdGhpcyBmaWxlIGFuZCBzZXQgaXQgaW4gdGVycmFmb3JtL3ZhcmlhYmxlcy50ZiwgYW5kIHdoYXRldmVyIGlzIGluIHRoaXMgc2NyaXB0IHdpbGwgYmUgcnVuIGF0IHN0YXJ0dXAgb2YgdGhlIFZNCnN1ZG8gZmlyZXdhbGwtb2ZmbGluZS1jbWQgLS16b25lPXB1YmxpYyAtLWFkZC1wb3J0PTgwODAvdGNwCndnZXQgaHR0cHM6Ly9naXRodWIuY29tL2dyYWFsdm0vZ3JhYWx2bS1jZS1idWlsZHMvcmVsZWFzZXMvZG93bmxvYWQvdm0tMjAuMS4wL2dyYWFsdm0tY2UtamF2YTExLWxpbnV4LWFtZDY0LTIwLjEuMC50YXIuZ3oKdGFyIC14ZiBncmFhbHZtLWNlLWphdmExMS1saW51eC1hbWQ2NC0yMC4xLjAudGFyLmd6CnJtIGdyYWFsdm0tY2UtamF2YTExLWxpbnV4LWFtZDY0LTIwLjEuMC50YXIuZ3oKZXhwb3J0IEpBVkFfSE9NRT0vaG9tZS9vcGMvZ3JhYWx2bS1jZS1qYXZhMTEtMjAuMS4wCmV4cG9ydCBQQVRIPSRKQVZBX0hPTUUvYmluOiRQQVRICnN1ZG8gc2ggLWMgJ2VjaG8gIldlbGNvbWUgTWljcm9uYXV0IEhPTCBBdHRlbmRlZSEiID4gL2V0Yy9tb3RkJwo="
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
