resource "aws_lb_target_group" "example_app_tg" {
  name                 = "${module.prefix.id}-example-app-tg"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = data.terraform_remote_state.base.outputs.vpc_module.vpc_id
  deregistration_delay = local.deregistration_delay

  health_check {
    enabled  = true
    interval = 30
    path     = "/"
    protocol = "HTTP"
    matcher  = "200-399"
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = merge(
    module.prefix.tags,
    {
      "Name" = "${module.prefix.id}-example-app-tg"
    },
  )
}

resource "aws_lb_listener_rule" "default" {
  listener_arn = data.terraform_remote_state.base.outputs.ecs_module.https_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example_app_tg.arn
  }

  condition {
    path_pattern {
      values = ["/", "/*"]
    }
  }

  condition {
    host_header {
      values = [
        "ecs-demo.${var.domain}"
      ]
    }
  }
}

resource "aws_ecs_task_definition" "example_app" {
  family                   = "${module.prefix.id}-example-app"
  task_role_arn            = aws_iam_role.ecs_tasks_role.arn
  execution_role_arn       = aws_iam_role.ecs_tasks_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  container_definitions = <<EOF
[
  {
    "name": "example-app",
    "image": "${var.app_image_repository}:${var.app_image_tag}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-create-group": "true",
        "awslogs-group": "${module.prefix.id}-example-app",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "example-app"
      }
    },
    "linuxParameters": {
      "initProcessEnabled": true
    },
    "environment": []
  }
]
EOF
  tags = merge(
    module.prefix.tags,
    {
      "Name" = "${module.prefix.id}-example-app"
    },
  )
}

resource "aws_ecs_service" "example_app_svc" {
  name            = "${module.prefix.id}-example-app-svc"
  cluster         = data.terraform_remote_state.base.outputs.ecs_module.cluster_id
  task_definition = aws_ecs_task_definition.example_app.arn

  desired_count          = 1
  enable_execute_command = true

  deployment_maximum_percent         = local.maximum_percent
  deployment_minimum_healthy_percent = local.minimum_healthy_percent

  load_balancer {
    target_group_arn = aws_lb_target_group.example_app_tg.arn
    container_name   = "example-app"
    container_port   = 80
  }

  network_configuration {
    subnets = data.terraform_remote_state.base.outputs.vpc_module.private_subnets
    security_groups = [
      data.terraform_remote_state.base.outputs.app_sg_id
    ]
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 1
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 4
    base              = 0
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_appautoscaling_target" "deafult" {
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"
  resource_id        = "service/${data.terraform_remote_state.base.outputs.ecs_module.cluster_name}/${aws_ecs_service.example_app_svc.name}"
  min_capacity       = 1
  max_capacity       = 4
}

resource "aws_appautoscaling_policy" "scale_out_policy" {
  name               = "scale-out"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.deafult.resource_id
  scalable_dimension = aws_appautoscaling_target.deafult.scalable_dimension
  service_namespace  = aws_appautoscaling_target.deafult.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 80
    disable_scale_in   = false
    scale_out_cooldown = 60
    scale_in_cooldown  = 300

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_route53_record" "default" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "ecs-demo.${var.domain}"
  type    = "CNAME"
  ttl     = 300
  records = [
    data.terraform_remote_state.base.outputs.ecs_module.dns_name
  ]
}
