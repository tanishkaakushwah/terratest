data "azurerm_network_interface" "nic" {
  for_each = var.vms
  name                = each.value.nic_name
  resource_group_name = each.value.rg_name
}

resource "azurerm_network_security_group" "nsg" {
  for_each=var.vms
  name                = "${each.key}_nsg"
  location            = each.value.location
  resource_group_name = each.value.rg_name

  dynamic "security_rule" {
    for_each= each.value.security_rules
    content{
    name                       = security_rule.value.name
    priority                   = security_rule.value.priority
    direction                  = security_rule.value.direction
    access                     = security_rule.value.access
    protocol                   = security_rule.value.protocol
    source_port_range          = security_rule.value.source_port_range
    destination_port_range     = security_rule.value.destination_port_range
    source_address_prefix      = security_rule.value.source_address_prefix
    destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  for_each = var.vms
  network_interface_id      = data.azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id 
}