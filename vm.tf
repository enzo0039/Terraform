resource "azurerm_public_ip" "move2cloud_public_ip" {
  name                = "move2cloud-public-ip"
  location            = azurerm_resource_group.move2cloud.location
  resource_group_name = azurerm_resource_group.move2cloud.name
  allocation_method   = "Static"
}

resource "azurerm_linux_virtual_machine" "move2cloud" {
  name                = "move2cloud-vm"
  resource_group_name = azurerm_resource_group.move2cloud.name
  location            = azurerm_resource_group.move2cloud.location
  size                = "Standard_DS1_v2"

  admin_username      = "admuser"
  admin_ssh_key {
    username   = "admuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  network_interface_ids = [azurerm_network_interface.move2cloud.id]
}

resource "azurerm_network_interface" "move2cloud" {
  name                = "move2cloud-nic"
  location            = azurerm_resource_group.move2cloud.location
  resource_group_name = azurerm_resource_group.move2cloud.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.move2cloud.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.move2cloud_public_ip.id
  }
}

resource "azurerm_subnet" "move2cloud" {
  name                 = "move2cloud-internal"
  resource_group_name  = azurerm_resource_group.move2cloud.name
  virtual_network_name = azurerm_virtual_network.move2cloud.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_virtual_network" "move2cloud" {
  name                = "move2cloud-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.move2cloud.location
  resource_group_name = azurerm_resource_group.move2cloud.name
}

resource "azurerm_network_security_group" "move2cloud_nsg" {
  name                = "move2cloud-nsg"
  location            = azurerm_resource_group.move2cloud.location
  resource_group_name = azurerm_resource_group.move2cloud.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "move2cloud_nic_association" {
  network_interface_id      = azurerm_network_interface.move2cloud.id
  network_security_group_id = azurerm_network_security_group.move2cloud_nsg.id
}

