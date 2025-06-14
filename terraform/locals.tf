locals {
  resource_location_name = replace(lower(data.azurerm_resource_group.predefined_resource_group.location), " ", "")
  dns_zone_resource_name = "streetcrocket.com"
}