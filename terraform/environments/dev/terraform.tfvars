rgs = {
  rg1 = {
    name       = "rg-pilu-dev-todoapp-01"
    location   = "centralindia"
    managed_by = "Terraform"
    tags = {
      env = "dev"
    }
  }
}

networks = {
  vnet1 = {
    name                = "vnet-pilu-dev-todoapp-01"
    location            = "centralindia"
    resource_group_name = "rg-pilu-dev-todoapp-01"
    address_space       = ["10.0.0.0/16"]
    tags = {
      environment = "dev"
    }
    subnets = [
      {
        name             = "frontend-subnet"
        address_prefixes = ["10.0.1.0/24"]
      },
      {
        name             = "backend-subnet"
        address_prefixes = ["10.0.2.0/24"]
      }
    ]
  }
}

public_ips = {
  app1 = {
    name                = "pip-pilu-dev-todoapp-01"
    resource_group_name = "rg-pilu-dev-todoapp-01"
    location            = "centralindia"
    allocation_method   = "Static"
    tags = {
      app = "frontend"
      env = "prod"
    }
  }
  app2 = {
    name                = "pip-pilu-dev-todoapp-02"
    resource_group_name = "rg-pilu-dev-todoapp-01"
    location            = "centralindia"
    allocation_method   = "Static"
    tags = {
      app = "frontend"
      env = "prod"
    }
  }
}


key_vaults = {
  kv1 = {
    kv_name  = "kv-dev-tani"
    location = "centralindia"
    rg_name  = "rg-pilu-dev-todoapp-01"
  }
}

secrets={
  frontend-vm={
    username="frontendadmin"
    password="P@ssword1234"
  }
  backend-vm={
    username="backendadmin"
    password="P@ssword1234"
  }
  sql-server={
    username="sqladminuser"
    password="P@ssword1234"
  }
}

vm = {
  vm1 = {
    nic_name    = "nic-frontend-vm-01"
    location    = "centralindia"
    rg_name     = "rg-pilu-dev-todoapp-01"
    vnet_name   = "vnet-pilu-dev-todoapp-01"
    subnet_name = "frontend-subnet"
    pip_name    = "pip-pilu-dev-todoapp-01"
    vm_name     = "frontend-vm"
    size        = "Standard_F2"
    kv_name     = "kv-dev-tani"
    secret_username = "frontend-vm-username"
    secret_password = "frontend-vm-passwd"
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
    security_rules = [
      {
        name                       = "Allow-HTTP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-SSH"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
  vm2 = {
    nic_name    = "nic-backend-vm-02"
    location    = "centralindia"
    rg_name     = "rg-pilu-dev-todoapp-01"
    vnet_name   = "vnet-pilu-dev-todoapp-01"
    subnet_name = "backend-subnet"
    pip_name    = "pip-pilu-dev-todoapp-02"
    vm_name     = "backend-vm"
    size        = "Standard_F2"
    kv_name     = "kv-dev-tani"
    secret_username = "backend-vm-username"
    secret_password = "backend-vm-passwd"
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
    security_rules = [
      {
        name                       = "Allow-HTTP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-SSH"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
}
