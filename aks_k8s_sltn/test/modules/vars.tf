
variable "env" {
  type    = string
  default = ""
}

variable "address" {              
  type    = list(string)
  default = []
}

variable "subnet" {              
  type    = list(string)
  default = []
}