variable "compartment_ocid" {}
variable "tenancy_ocid" {}
variable "region" {}

variable "custom_image_id" {
  default = "ocid1.image.oc1..aaaaaaaa2es7kqqgmmjyymzdaaeqmmehrprg6gdjxs4on5lpzwiv64przksa"
}

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
  default = "IyEvYmluL3NoCnN1ZG8gZmlyZXdhbGwtY21kIC0tcGVybWFuZW50IC0tem9uZT1wdWJsaWMgLS1hZGQtcG9ydD04MDgwL3RjcApzdWRvIGZpcmV3YWxsLWNtZCAtLXJlbG9hZApzdWRvIHNoIC1jICdlY2hvICJXZWxjb21lIE1pY3JvbmF1dCBIT0wgQXR0ZW5kZWUhIiA+IC9ldGMvbW90ZCcK"
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
