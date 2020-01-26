variable "resource_group_name" {
  description = "The name of the Resource Group where the Domain Controller resources will be created"
}

variable "location" {
  description = "The Azure Region in which the Resource Group exists"
}
variable "network_security_group_id" {
  description = "The ID of the network security group created in main."
}
variable "subnetID" {
  description = "The ID of the subnet created in main."
}

variable "dns_server_ip" {
  description = "The IP of the DC1 VM, to be used as the DNS server address for client1"
}

variable "active_directory_domain" {
  description = "The name of the Active Directory domain, for example `consoto.local`"
}

variable "admin_username" {
  description = "The username associated with the local administrator account on the virtual machine"
}

variable "admin_password" {
  description = "The password associated with the local administrator account on the virtual machine"
}