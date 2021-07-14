variable "stage" {
  type = string
  description = "Stage name e.g. prod, dev, nonprod, etc"
}

variable "domain" {
  type = string
  description = "Domain name to use for ALB"
}

variable "region" {
  type = string
  description = "AWS Region"
}

variable "state_bucket" {
  type = string
  description = "Bucket to be used for remote state"
}

variable "app_image_repository" {
  type = string
  description = "Docker image repository"
}

variable "app_image_tag" {
  type = string
  description = "Docker Image tag for the application to be deployed"
}
