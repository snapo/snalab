locals{
    virtual_machine_name  = "DC1"
}

# Public IP
resource "azurerm_public_ip" "dc1-publicip" {
    name                         = "dc1-pip"
    location                     = "uksouth"
    resource_group_name          = "${var.resource_group_name}"
    public_ip_address_allocation = "dynamic"
}

# DC1 NIC
resource "azurerm_network_interface" "dc1_nic" {
    name                      = "dc1_nic"
    location                  = "uksouth"
    resource_group_name       = "${var.resource_group_name}"
    network_security_group_id = "${var.network_security_group_id}"

    ip_configuration {
        name                          = "dc1"
        subnet_id                     = "${var.subnet_id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = "${azurerm_public_ip.dc1-publicip.id}"
    }
}

resource "azurerm_virtual_machine" "dc1" {
    name                  = "${local.virtual_machine_name}"
    location              = "${var.location}"
    resource_group_name   = "${var.resource_group_name}"
    vm_size               = "Standard_B2s"
    network_interface_ids = ["${azurerm_network_interface.dc1_nic.id}"]
    delete_os_disk_on_termination = true

    storage_os_disk {
        name              = "DC1-OsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2019-Datacenter"
        version   = "latest"
  }

    os_profile {
        computer_name  = "${local.virtual_machine_name}"
        admin_username = "mike"
        #Lab password
        admin_password = "PleaseUseMyPassword2018"
    }

    os_profile_windows_config{
        provision_vm_agent        = true
        enable_automatic_upgrades = true
    }
}