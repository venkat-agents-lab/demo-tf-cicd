output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.this.name
}

output "subnet_name" {
  value = azurerm_subnet.this.name
}

output "vm_private_ip_address" {
  value = azurerm_network_interface.this.ip_configuration[0].private_ip_address
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.this.id
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.this.name
}
