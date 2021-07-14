terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "ecs-demo-terraform"
    key    = "iac/example-app-deploy/terraform.tfstate"
    region = "us-west-2"
  }
}
