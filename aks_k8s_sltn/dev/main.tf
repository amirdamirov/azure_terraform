module "dev_k8s" {
  source       = "../modules/aks"
  env          = "dev"
  location     = "northeurope"
  }