terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.3.0"
}

# Configure the Microsoft Azure provider
provider "azurerm" {
  features {}
  subscription_id = "e6fdeeb6-2367-40d0-b980-ab5cb9be4885"
}

# Module: Resource Group
module "resource_group" {
  source  = "./modules/resource_group"
  name    = "my-terraform-rg"
  location = "West Europe"
}

# Module: Virtual Network
module "virtual_network" {
  source              = "./modules/virtual_network"
  name                = "my-terraform-vnet"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  address_space       = ["10.0.0.0/16"]
}

# Module: Subnet
module "subnet" {
  source              = "./modules/subnet"
  name                = "my-terraform-subnet"
  resource_group_name = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Module: Network Interface
module "network_interface" {
  source              = "./modules/network_interface"
  name                = "my-terraform-nic"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  subnet_id           = module.subnet.id
}

# Module: Virtual Machine
module "linux_virtual_machine" {
  source                  = "./modules/linux_virtual_machine"
  name                    = "my-terraform-vm"
  location                = module.resource_group.location
  resource_group_name     = module.resource_group.name
  network_interface_ids   = [module.network_interface.id]
  size                    = "Standard_DS1_v2"
  computer_name           = "myvm"
  admin_username          = "azureuser"
  admin_password          = "Password1234!"  # NOTE: Use secure methods like Vault for sensitive values
  disable_password_authentication = false
  source_image_reference = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  os_disk = {
    name                 = "my-terraform-os-disk"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
