module "dev_k8s" {
  source           = "../modules/aks"
  env              = "dev"
  location         = "northeurope"
  hubVnetAddress   = ["10.200.0.0/24"]
  firewallSubnet   = ["10.200.0.0/26"]
  gatewaysubnet    = ["10.200.0.64/27"]
  bastionsubnet    = ["10.200.0.96/27"]
  spokeVnetAddress = ["10.240.0.0/16"] 
  akssubnet        = ["10.240.0.0/22"]
  akslbsubnet      = ["10.240.4.0/28"]
  }