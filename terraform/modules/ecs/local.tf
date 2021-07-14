locals {

  fargate_cp_name      = "${module.prefix.id}-fargate"
  fargate_spot_cp_name = "${module.prefix.id}-fargate-spot"

  tags = {
    "ManagedBy" = "Terraform"
  }
}

module "prefix" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.22.1"
  namespace  = var.namespace
  stage      = var.stage
  delimiter  = "-"

  tags = {
    "Project" = var.namespace,
  }
}
