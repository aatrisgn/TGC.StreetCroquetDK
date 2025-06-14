terraform {
  backend "azurerm" {
    use_azuread_auth = true
    use_oidc         = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.0.0"
    }
  }
}

resource "azurerm_static_web_app" "primary_static_web_app" {
  name                = "swa-streetcroquetdk-${var.environment_type_name}-${local.resource_location_name}"
  resource_group_name = data.azurerm_resource_group.predefined_resource_group.name
  location            = data.azurerm_resource_group.predefined_resource_group.location
  sku_tier            = "Free"
  sku_size            = "Free"
}

resource "azurerm_static_web_app_custom_domain" "custom_domain" {
  static_web_app_id = azurerm_static_web_app.primary_static_web_app.id
  domain_name       = "streetcrocket.com"
  validation_type   = "cname-delegation"
}