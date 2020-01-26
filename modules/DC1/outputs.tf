output "out_dc_location" {
  value = "${azurerm_virtual_machine_extension.create-active-directory.location}"
}

output "out_dc_ipaddress" {
  value = "${azurerm_network_interface.dc1_nic.private_ip_address}"
}