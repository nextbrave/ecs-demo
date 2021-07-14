variable "stage" {
  type = string
  description = "Stage name e.g. prod, dev, nonprod, etc"
}

variable "domain" {
  type = string
  description = "Domain name to use for ALB"
}

variable "vpc_cidr" {
  type = string
  description = "CIDR IP range for VPC"
}

variable "vpc_availability_zones" {
  type = list(string)
  description = "Availability zones to be used for the VPC"
}

variable "vpc_private_subnets" {
  type = list(string)
  description = "CIDR IP ranges for the private subnets"
}

variable "vpc_public_subnets" {
  type = list(string)
  description = "CIDR IP ranges for the public subnets"
}
