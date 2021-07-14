output "vpc_module" {
  value = module.vpc
}

output "ecs_module" {
  value = module.ecs_cluster
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "app_sg_id" {
  value = aws_security_group.app.id
}
