variable "public_subnet_cidrs" {
  type = list(string)
  description = "public subnet cidr value"
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type = list(string)
  description = "private subnet cidr value"
  default = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "azs" {
  type = list(string)
  description = "availability"
  default = ["ap-southeast-1a", "ap-southeast-1b"]
}
