output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "load_balancer_dns" {
  value = module.alb.load_balancer_dns
}

output "cluster_id" {
  value = module.ecs.cluster_id
}

output "service_name" {
  value = module.service.service_name
}
