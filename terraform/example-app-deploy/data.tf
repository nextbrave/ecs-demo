data "aws_route53_zone" "hosted_zone" {
  name = "${var.domain}."
}

data "aws_iam_role" "ecs_role" {
  name = "AWSServiceRoleForECS"
}

data "terraform_remote_state" "base" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = "iac/base/terraform.tfstate"
    region = var.region
  }
}
