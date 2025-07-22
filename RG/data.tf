data "azurerm_client_config" "current" {
  # this data source is used to get the object_id of the service principal
  # it is needed to create a role assignment for the service principal
}