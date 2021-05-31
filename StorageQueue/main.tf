data "terraform_remote_state" "ResourceGroup" {
  backend = "local"

  config = {
    path="../ResourceGroup/terraform.tfstate"
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = "${data.terraform_remote_state.ResourceGroup.outputs.resource_group_name}"
  location                 = "${data.terraform_remote_state.ResourceGroup.outputs.resource_group_location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}



resource "azurerm_storage_queue" "storage" { 
  name                 = var.queue_name
  storage_account_name = azurerm_storage_account.storage.name
}