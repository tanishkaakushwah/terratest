output "frontend_ip_address" {
  value = azurerm_public_ip.pip["app1"].ip_address
}