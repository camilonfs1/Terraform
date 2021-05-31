data "terraform_remote_state" "ResourceGroup" {
  backend = "local"

  config = {
    path="../ResourceGroup/terraform.tfstate"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-nimitzv2"
  address_space       = ["10.30.0.0/16"]
  location            = "${data.terraform_remote_state.ResourceGroup.outputs.resource_group_location}"
  resource_group_name = "${data.terraform_remote_state.ResourceGroup.outputs.resource_group_name}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "snet-appnimitz"
  resource_group_name  = "${data.terraform_remote_state.ResourceGroup.outputs.resource_group_name}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.30.1.0/24"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "AKSClusterNimitz-2"
  location            = "${data.terraform_remote_state.ResourceGroup.outputs.resource_group_location}"
  resource_group_name =  "${data.terraform_remote_state.ResourceGroup.outputs.resource_group_name}"
  dns_prefix          = "exampleaks1"
  netwok_resource_group     = azurerm_virtual_network.vnet.resource_group_name

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
  
  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }
}

