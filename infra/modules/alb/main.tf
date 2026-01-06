###############################################
# Public Application Load Balancer (ALB)
# - Exposes the service to the internet
# - Listens on port 80 (HTTP)
# - Forwards traffic to ECS tasks on port 8000
###############################################
resource "aws_lb" "this" {
  name               = var.lb_name
  internal           = false                     # Internet-facing ALB
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]   # ALB security group
  subnets            = var.subnet_ids            # Public subnets
}

#########################################################
# Target Group
# - Routes traffic from ALB to ECS tasks
# - Uses IP mode because Fargate tasks have ENIs
# - Health check uses /docs (FastAPI Swagger UI)
#########################################################
resource "aws_lb_target_group" "this" {
  name        = "${var.lb_name}-tg"
  port        = 8000                              # FastAPI container port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"                              # Required for Fargate

  health_check {
    path                = "/docs"                 # FastAPI health endpoint
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

#########################################################
# Listener
# - Accepts HTTP traffic on port 80
# - Forwards all requests to the target group
#########################################################
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
