module "k8s" {
  source       = "../_module"
  cluster_name = "aks"
  env_name     = "dev"

}