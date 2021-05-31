output "kv_id" {
  value = azurerm_key_vault.keyvault.id
}

output "vault_uri" {
  value = azurerm_key_vault.keyvault.vault_uri
}

output "tenantId" {
  value = data.azurerm_client_config.current.tenant_id
}


