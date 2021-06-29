module "dev_env" {
  source       = "../modules"
  env          = "dev"
  address      = ["10.0.0.0/20"]
  subnet       = ["10.0.0.0/24"]

}