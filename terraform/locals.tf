locals {
  resource_location_name = replace(lower(data.azurerm_resource_group.predefined_resource_group.location), " ", "")
}