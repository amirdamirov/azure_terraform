variable "location" {}

variable "prefix" {
  type    = string
  default = "dev"
}

variable "zones" {              
  type    = list(string)
  default = []
}

variable "tags" {
  type = map(string)

  default = {
    dev  = "development",
    prod = "production"
  }
}