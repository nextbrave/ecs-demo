resource "aws_ecs_cluster" "default" {
  name                = "${module.prefix.id}-ecs-cluster"
  capacity_providers  = var.enable_fargate ? ["FARGATE", "FARGATE_SPOT"] : []

  tags = merge(
    module.prefix.tags,
    local.tags,
    {
      "Name" = "${module.prefix.id}-ecs-cluster"
    },
  )
}

resource "aws_lb" "default" {
  count              = var.enable_alb ? 1 : 0
  name               = "${module.prefix.id}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_security_group_ids
  subnets            = var.alb_subnet_ids

  enable_deletion_protection = var.alb_deletion_protection

  tags = merge(
    module.prefix.tags,
    local.tags,
    {
      "Name" = "${module.prefix.id}-alb"
    },
  )
}

resource "aws_lb_listener" "http_listener" {
  count             = var.enable_alb ? 1 : 0
  load_balancer_arn = aws_lb.default[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      port = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  count             = var.enable_alb ? 1 : 0
  load_balancer_arn = aws_lb.default[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.alb_acm_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = lookup(var.alb_default_https_action, "content_type", "text/plain")
      message_body = lookup(var.alb_default_https_action, "message_body", "default-action")
      status_code  = lookup(var.alb_default_https_action, "status_code", "200")
    }
  }
}
