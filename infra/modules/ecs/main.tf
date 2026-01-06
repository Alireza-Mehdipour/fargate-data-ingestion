############################################################
# ECS Cluster
# - Logical grouping of ECS services and tasks
# - Fargate tasks will run inside this cluster
############################################################
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

############################################################
# IAM Role for ECS Task Execution
# - Allows ECS tasks to pull images from ECR
# - Allows tasks to write logs to CloudWatch
############################################################
resource "aws_iam_role" "task_execution" {
  name               = "${var.cluster_name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
}

# Trust policy: ECS tasks can assume this role
data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Attach AWS-managed policy for pulling images + logging
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

############################################################
# ECS Task Definition
# - Defines how your FastAPI container runs
# - Specifies CPU, memory, networking mode, and container config
# - Points to your ECR image
############################################################
resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  network_mode             = "awsvpc"              # Required for Fargate
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"                 # 0.25 vCPU
  memory                   = "512"                 # 0.5 GB RAM
  execution_role_arn       = aws_iam_role.task_execution.arn

  # Container configuration
  container_definitions = jsonencode([
    {
      name  = "app"
      image = var.image_url

      portMappings = [
        {
          containerPort = 8000                     # FastAPI port
          protocol      = "tcp"
        }
      ]
    }
  ])
}
