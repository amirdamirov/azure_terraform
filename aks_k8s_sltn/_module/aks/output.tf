# resource "local_file" "kubeconfig" {
#   depends_on   = [azurerm_kubernetes_cluster.dev]
#   filename     = "kubeconfig"
#   content      = azurerm_kubernetes_cluster.dev.kube_config_raw
# }

# output "client_certificate" {
#   value = azurerm_kubernetes_cluster.dev.kube_config.0.client_certificate
# }

