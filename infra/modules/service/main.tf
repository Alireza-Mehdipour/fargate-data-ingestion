###############################################
# ECS Fargate Service
# - Runs the FastAPI container on Fargate
# - Registers tasks with the ALB target group
# - Uses awsvpc networking (required for Fargate)
###############################################
resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn
  launch_type     = "FARGATE"
  desired_count   = 1

  # Attach service to the ALB target group
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = 8000
  }

  # Required for Fargate networking
  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.security_group_id]
    assign_public_ip = true
  }

  # Ensure service updates safely
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
}
