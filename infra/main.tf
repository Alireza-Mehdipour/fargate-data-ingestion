###############################################
# Data sources for existing VPC + subnets
###############################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

###############################################
# Security Group for ALB (public access)
###############################################
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP"
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
}

###############################################
# Security Group for ECS Tasks
###############################################
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Allow traffic from ALB"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "Allow ALB to reach ECS tasks"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

###############################################
# ECR Module
###############################################
module "ecr" {
  source          = "./modules/ecr"
  repository_name = "fargate-demo-repo"
}

###############################################
# ECS Module (updated to use versioned tags)
###############################################
module "ecs" {
  source       = "./modules/ecs"
  cluster_name = "fargate-cluster"
  task_family  = "fargate-task"

  # Pass image URL and tag separately
  image_url = module.ecr.repository_url
  image_tag = var.image_tag
}

###############################################
# ALB Module
###############################################
module "alb" {
  source            = "./modules/alb"
  lb_name           = "fargate-alb"
  vpc_id            = data.aws_vpc.default.id
  subnet_ids        = data.aws_subnets.default.ids
  security_group_id = aws_security_group.alb_sg.id
}

###############################################
# Service Module (Fargate)
###############################################
module "service" {
  source              = "./modules/service"
  service_name        = "fargate-service"
  cluster_id          = module.ecs.cluster_id
  task_definition_arn = module.ecs.task_definition_arn
  target_group_arn    = module.alb.target_group_arn
  subnet_ids          = data.aws_subnets.default.ids
  security_group_id   = aws_security_group.ecs_sg.id
}
