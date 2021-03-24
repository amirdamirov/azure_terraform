variable "location" {}

variable "tags" {
  type    = map(string)

  default = {
    dev      = "development",
    prod     = "production"
  }
}