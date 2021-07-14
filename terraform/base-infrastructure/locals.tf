locals {
  namespace = "ecs-demo"
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
