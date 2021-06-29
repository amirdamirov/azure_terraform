module "qa_k8s" {
  source       = "../modules/aks"
  env          = "qa"
  location     = "northeurope"
}