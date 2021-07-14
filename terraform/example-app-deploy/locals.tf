locals {
  namespace = "ecs-demo"

  minimum_healthy_percent = 50
  maximum_percent         = 200

  deregistration_delay    = 30
}


module "prefix" {
  source     = "cloudposse/label/null"
  version    = "0.24.1"

  namespace  = local.namespace
  stage      = var.stage
  delimiter  = "-"

  tags = {
    "ManagedBy" = "Terraform",
    "Project"   = "ECS Demo"
  }
}
