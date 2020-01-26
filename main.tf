provider "azurerm" {
    version = "=1.28.0"
}

# Resource Group
resource "azurerm_resource_group" "lw-activedirectory-lab" {
    name     = "lw-activedirectory-lab"
    location = "uksouth"
}

# Virtual Network
resource "azurerm_virtual_network" "labnetwork" {
  name                = "lab-net"
  resource_group_name = "${azurerm_resource_group.lw-activedirectory-lab.name}"
  location            = "${azurerm_resource_group.lw-activedirectory-lab.location}"
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "subnet" {
    name                 = "lab-subnet"
    resource_group_name  = "${azurerm_resource_group.lw-activedirectory-lab.name}"
    virtual_network_name = "${azurerm_virtual_network.labnetwork.name}"
    address_prefix       = "10.0.1.0/24"
}

# Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
    name                = "Lab-NSG"
    location            = "uksouth"
    resource_group_name = "${azurerm_resource_group.lw-activedirectory-lab.name}"

    security_rule {
        name                       = "RDP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

module "domain-controller"{
    source              = "./modules/DC1"
    location            = "${azurerm_resource_group.lw-activedirectory-lab.location}"
    resource_group_name = "${azurerm_resource_group.lw-activedirectory-lab.name}"
    subnet_id           = "${azurerm_subnet.subnet.id}"
    network_security_group_id = "${azurerm_network_security_group.nsg.id}"
    active_directory_domain       = "sys.li"
    active_directory_netbios_name = "SNALAB"
    admin_username                = "mike"
    admin_password                = "PleaseUseMyPassword2018!"
}

module "client1"{
    source      = "./modules/CLI1"
    location            = "${module.domain-controller.out_dc_location}"
    resource_group_name = "${azurerm_resource_group.lw-activedirectory-lab.name}"
    subnetID            = "${azurerm_subnet.subnet.id}"
    dns_server_ip       = "${module.domain-controller.out_dc_ipaddress}"
    network_security_group_id = "${azurerm_network_security_group.nsg.id}"
    active_directory_domain   = "sys.li"
    admin_username            = "mike"
    admin_password            = "PleaseUseMyPassword2018!"
}