data "azurerm_client_config" "current" {}

data "terraform_remote_state" "ResourceGroup" {
  backend = "local"

  config = {
    path="../ResourceGroup/terraform.tfstate"
  }
}

data "terraform_remote_state" "ActiveDirectory" {
  backend = "local"

  config = {
    path="../ActiveDirectory/terraform.tfstate"
  }
}

resource "azurerm_key_vault" "keyvault" {
  name                        = var.keyvault_name
  location                    = "${data.terraform_remote_state.ResourceGroup.outputs.resource_group_location}"
  resource_group_name         = "${data.terraform_remote_state.ResourceGroup.outputs.resource_group_name}"
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${data.azurerm_client_config.current.object_id}"
    application_id  = "${data.terraform_remote_state.ActiveDirectory.outputs.appId}"

    key_permissions = [
      "create",
      "get",
      "list"
    ]

    secret_permissions = [
      "set",
      "list",
      "get",
      "delete",
      "purge",
      "recover"
    ]

    storage_permissions = [
      "Get",
      "Set",
      "list"
    ]
  }
}

resource "azurerm_key_vault_secret" "keyvault" {
  name         = var.secret_name
  value        = var.secret_value
  key_vault_id = azurerm_key_vault.keyvault.id
}