data "aws_acm_certificate" "https_certificate" {
  domain   = "*.${var.domain}"
  statuses = ["ISSUED"]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name = "${module.prefix.id}-vpc"
  cidr = var.vpc_cidr
  azs  = var.vpc_availability_zones

  private_subnets        = var.vpc_private_subnets
  public_subnets         = var.vpc_public_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  vpc_tags = merge(module.prefix.tags, {
    "Name" = "${module.prefix.id}-vpc"
  })
}

resource "aws_security_group" "alb" {
  name        = "${module.prefix.id}-alb-sg"
  description = "ALB security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTPS ingress rule"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP ingress rule"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${module.prefix.id}-alb-sg"
  }
}

resource "aws_security_group" "app" {
  name        = "${module.prefix.id}-app-sg"
  description = "Appliation security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "All access to load balancer security group"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [
      aws_security_group.alb.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${module.prefix.id}-app-sg"
  }
}

module "ecs_cluster" {
  source         = "../modules/ecs"
  namespace      = local.namespace
  stage          = var.stage
  enable_fargate = true
  enable_alb     = true

  alb_deletion_protection = false
  alb_security_group_ids  = [
    aws_security_group.alb.id
  ]

  alb_subnet_ids = module.vpc.public_subnets
  alb_acm_arn = data.aws_acm_certificate.https_certificate.arn

  alb_default_https_action = {
    content_type = "text/html"
    message_body = "<h1>Under construction</h1>"
    status_code  = "200"
  }

  fargate_weight = 1
  fargate_base   = 1
  fargate_spot_weight = 4
  fargate_spot_base = 0
}
