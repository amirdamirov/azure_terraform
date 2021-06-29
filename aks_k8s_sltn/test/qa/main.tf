module "qa_env" {
  source       = "../modules"
  env          = "qa"
  address      = ["10.100.0.0/20"]
  subnet       = ["10.100.0.0/24"]
}
