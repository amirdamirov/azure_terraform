variable "location" {}

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