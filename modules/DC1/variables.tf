variable "resource_group_name" {
  description = "The name of the Resource Group where the Domain Controller resources will be created"
}

variable "location" {
  description = "The Azure Region in which the Resource Group exists"
}

variable "subnet_id" {
  description = "The Subnet ID which the Domain Controller's NIC should be created in"
}

variable "network_security_group_id" {
  description = "The ID of the NSG created in main."
}

variable "active_directory_domain" {
  description = "The name of the Active Directory domain, for example `consoto.local`"
}

variable "active_directory_netbios_name" {
  description = "The netbios name of the Active Directory domain, for example `consoto`"
}

variable "admin_username" {
  description = "The username associated with the local administrator account on the virtual machine"
}

variable "admin_password" {
  description = "The password associated with the local administrator account on the virtual machine"
}