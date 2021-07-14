variable "namespace" {
  type = string
  description = "Namespace for the prefix"
}

variable "stage" {
  type = string
  description = "Stage for the prefix"
}

variable "enable_fargate" {
  type = bool
  default = true
  description = "Enable the usage of Fargate instances"
}

variable "fargate_weight" {
  type = number
  default = 0
  description = "Weight for the FARGATE capacity provider"
}

variable "fargate_base" {
  type = number
  default = 0
  description = "Base for the FARGATE capacity provider"
}

variable "fargate_spot_weight" {
  type = number
  default = 0
  description = "Weight for the FARGATE_SPOT capacity provider"
}

variable "fargate_spot_base" {
  type = number
  default = 0
  description = "Base for the FARGATE_SPOT capacity provider"
}

variable "enable_alb" {
  type = bool
  default = false
  description = "Enable the creation of an Application Load Balancer"
}

variable "alb_security_group_ids" {
  type = list(string)
  default = []
  description = "List of security group ids for the application load balancers"
}

variable "alb_subnet_ids" {
  type = list(string)
  default = []
  description = "List of subnet group ids for the application load balancer"
}

variable "alb_deletion_protection" {
  type = bool
  default = false
  description = "Protect application load balancer against deletion"
}

variable "alb_acm_arn" {
  type = string
  default = ""
  description = "ACM Certificate ARN for the application HTTPS listener"
}

variable "alb_default_https_action" {
  type = any
  description = "The default action for the HTTPS listener. Currently it only accepts the fixed-response action"
  default = {
    type = "fixed-response"
    content_type = "text/plain"
    message_body = "This is the default action"
    status_code  = "200"
  }
}
