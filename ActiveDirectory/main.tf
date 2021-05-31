
# Create an application
resource "azuread_application" "app" {
  name = var.app_name
}

# Create a service principal
resource "azuread_service_principal" "app" {
  application_id = "${azuread_application.app.application_id}"
}