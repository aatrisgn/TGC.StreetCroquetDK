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

resource "azurerm_dns_zone" "dns_zone" {
  name                = local.dns_zone_resource_name
  resource_group_name = data.azurerm_resource_group.predefined_resource_group.name
}

resource "azurerm_static_web_app_custom_domain" "example" {
  static_web_app_id = azurerm_static_web_app.primary_static_web_app.id
  domain_name       = local.dns_zone_resource_name
  validation_type   = "dns-txt-token"
}

resource "azurerm_dns_txt_record" "example" {
  count               = azurerm_static_web_app_custom_domain.example.validation_token == null || azurerm_static_web_app_custom_domain.example.validation_token == "" ? 0 : 1
  name                = "_dnsauth"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = data.azurerm_resource_group.predefined_resource_group.name
  ttl                 = 300
  record {
    value = azurerm_static_web_app_custom_domain.example.validation_token
  }
}

resource "azurerm_dns_a_record" "example" {
  name                = "@"
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = data.azurerm_resource_group.predefined_resource_group.name
  ttl                 = 300
  target_resource_id  = azurerm_static_web_app.primary_static_web_app.id
}