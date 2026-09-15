resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  name                 = var.subnet_name
  resource_group_name   = azurerm_resource_group.this.name
  virtual_network_name  = azurerm_virtual_network.this.name
  address_prefixes      = var.subnet_address_prefixes
}

resource "azurerm_network_security_group" "this" {
  name                = "nsg-${var.vm_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags

  security_rule {
    name                       = "Allow-SSH-From-VPN"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allowed_ssh_source_cidr
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_network_interface" "this" {
  name                = "nic-${var.vm_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vm_private_ip_address
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = var.vm_name
  computer_name       = var.computer_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.this.id]
  disable_password_authentication = true
  provision_vm_agent             = true
  allow_extension_operations      = true
  tags                           = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  plan {
    name      = var.image_sku
    publisher = "RedHat"
    product   = "RHEL"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = var.image_sku
    version   = "latest"
  }
}
