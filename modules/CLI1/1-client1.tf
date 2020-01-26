
resource "azurerm_public_ip" "client1_pip" {
    name                         = "client1-publicip"
    location                     = "uksouth"
    resource_group_name          = "${var.resource_group_name}"
    public_ip_address_allocation = "dynamic"
}

resource "azurerm_network_interface" "client1_nic" {
    name                      = "client1_nic"
    location                  = "uksouth"
    resource_group_name       = "${var.resource_group_name}"
    network_security_group_id = "${var.network_security_group_id}"
    dns_servers               = ["${var.dns_server_ip}"]

    ip_configuration {
        name                          = "client1"
        subnet_id                     = "${var.subnetID}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.client1_pip.id}"
    }
}

resource "azurerm_virtual_machine" "client1" {
    name                = "client1"
    resource_group_name = "${var.resource_group_name}"
    location            = "${var.location}"
    vm_size             = "Standard_B2s"
    network_interface_ids = ["${azurerm_network_interface.client1_nic.id}"]
    delete_os_disk_on_termination = true

    storage_os_disk{
        name              = "CLI1-OsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference{
        publisher   = "MicrosoftWindowsDesktop"
        offer       = "Windows-10"
        sku         = "rs1-enterprise"
        version     = "latest"
    }

    os_profile {
        computer_name  = "client1"
        admin_username = "${var.admin_username}"
        admin_password = "${var.admin_password}"
    }

    os_profile_windows_config{
        provision_vm_agent        = true
        enable_automatic_upgrades = true
    }
}
