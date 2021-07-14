output "cluster_id" {
  value = aws_ecs_cluster.default.id
}

output "cluster_arn" {
  value = aws_ecs_cluster.default.arn
}

output "cluster_name" {
  value = aws_ecs_cluster.default.name
}

output "alb_id" {
  value = var.enable_alb ? aws_lb.default[0].id : ""
}

output "alb_arn" {
  value = var.enable_alb ? aws_lb.default[0].arn : ""
}

output "dns_name" {
  value = var.enable_alb ? aws_lb.default[0].dns_name : ""
}

output "zone_id" {
  value = var.enable_alb ? aws_lb.default[0].zone_id : ""
}

output "http_listener_id" {
  value = var.enable_alb ? aws_lb_listener.http_listener[0].id : ""
}

output "http_listener_arn" {
  value = var.enable_alb ? aws_lb_listener.http_listener[0].arn : ""
}

output "https_listener_id" {
  value = var.enable_alb ? aws_lb_listener.https_listener[0].id : ""
}

output "https_listener_arn" {
  value = var.enable_alb ? aws_lb_listener.https_listener[0].arn : ""
}
