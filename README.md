# 🚀 Fargate Data Ingestion — FastAPI on AWS ECS/Fargate (Terraform + Docker)

A production‑grade FastAPI application deployed on **AWS Fargate** using **Terraform**, **ECS**, **ECR**, **ALB**, and **Docker**.  
This project demonstrates real DevOps engineering skills: containerization, IaC, cloud architecture, CI/CD‑ready structure, and secure, scalable deployment patterns.

---

## 🌐 Project Overview

This project showcases a fully containerized FastAPI service running on AWS Fargate behind an Application Load Balancer.  
It is designed as a **portfolio‑grade example** of modern cloud deployment using Infrastructure as Code.

Key features include:

- FastAPI application packaged in a lightweight Docker image  
- AWS ECS Fargate service with autoscaling‑ready configuration  
- Application Load Balancer with health checks and routing  
- Private ECR repository for image storage  
- Modular Terraform structure for clean, reusable IaC  
- CloudWatch logging for observability  
- Public endpoint for testing and demonstration  

---

## 📸 Application Screenshot

![FastAPI running on AWS Fargate](screenshot.png)

Live URL: [`http://fargate-alb-602558180.ap-southeast-2.elb.amazonaws.com`](http://fargate-alb-602558180.ap-southeast-2.elb.amazonaws.com)

---

## 🏗️ Architecture

**AWS Services Used:**

- **ECS Fargate** — serverless container compute  
- **ECR** — container registry  
- **ALB** — traffic routing and health checks  
- **VPC + Subnets** — networking foundation  
- **CloudWatch Logs** — application logging  
- **IAM** — secure role‑based access  

**High‑Level Flow:**

1. Docker image is built locally and pushed to ECR  
2. Terraform provisions ECS cluster, task definition, service, ALB, and networking  
3. ECS Fargate pulls the image and runs the FastAPI container  
4. ALB exposes the application publicly  
5. Logs stream to CloudWatch for monitoring  

---

## 📁 Repository Structure

```
fargate-data-ingestion/
├── app/                         # FastAPI application source code
│   ├── main.py                  # Entry point for the API
│   └── requirements.txt         # Python dependencies
│
├── docker/
│   └── Dockerfile               # Docker image definition for FastAPI
│
├── terraform/
│   ├── modules/                 # Reusable Terraform modules (VPC, ECS, ALB, ECR)
│   │   ├── ecs/                 # ECS cluster, task definition, service
│   │   ├── alb/                 # Application Load Balancer + listeners
│   │   ├── ecr/                 # ECR repository module
│   │   └── networking/          # VPC, subnets, routing
│   │
│   ├── environments/
│   │   └── dev/                 # Environment-specific variables (dev)
│   │       ├── main.tfvars
│   │       └── backend.tf
│   │
│   ├── main.tf                  # Root Terraform configuration
│   ├── variables.tf             # Input variables
│   ├── outputs.tf               # Output values (ALB URL, ECR repo, etc.)
│   └── providers.tf             # AWS provider configuration
│
├── .gitignore                   # Git ignore rules
├── README.md                    # Project documentation
└── LICENSE                      # MIT License
```

---

## 🐳 Local Development

Build and run the FastAPI app locally:

```bash
docker build -t fargate-data-ingestion:v1.0.3 .
docker run -p 8000:8000 fargate-data-ingestion:v1.0.3
```

Visit the application locally:

```
http://localhost:8000
```

---

## ☁️ Deployment Workflow (Terraform + ECR)

### 1. Build the Docker image
```bash
docker build -t fargate-data-ingestion:v1.0.3 .
```

### 2. Authenticate Docker to AWS ECR
```bash
aws ecr get-login-password --region ap-southeast-2 \
  | docker login --username AWS \
  --password-stdin 014208336048.dkr.ecr.ap-southeast-2.amazonaws.com
```

### 3. Tag the image for ECR
```bash
docker tag fargate-data-ingestion:v1.0.3 \
  014208336048.dkr.ecr.ap-southeast-2.amazonaws.com/fargate-data-ingestion:v1.0.3
```

### 4. Push the image to ECR
```bash
docker push \
  014208336048.dkr.ecr.ap-southeast-2.amazonaws.com/fargate-data-ingestion:v1.0.3
```

### 5. Deploy infrastructure with Terraform
```bash
terraform init
terraform plan
terraform apply
```

### 6. ECS Fargate automatically pulls:
```
014208336048.dkr.ecr.ap-southeast-2.amazonaws.com/fargate-data-ingestion:v1.0.3
```

---

## 🧩 Terraform Example (Task Definition Snippet)

```hcl
container_definitions = jsonencode([
  {
    name      = "fastapi-app"
    image     = "014208336048.dkr.ecr.ap-southeast-2.amazonaws.com/fargate-data-ingestion:v1.0.3"
    essential = true

    portMappings = [
      {
        containerPort = 8000
        hostPort      = 8000
        protocol      = "tcp"
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/fargate-data-ingestion"
        awslogs-region        = "ap-southeast-2"
        awslogs-stream-prefix = "ecs"
      }
    }
  }
])
```

---

## 🎯 Purpose of This Project

This project was built to demonstrate:

- Real‑world DevOps and Cloud Engineering skills  
- Ability to design and deploy containerized applications  
- Proficiency with Terraform and AWS services  
- Clean, modular, production‑ready infrastructure  
- Strong documentation and engineering communication  

---

## 👤 Author

**Alireza Mehdipour**  
Cloud & DevOps Engineer  
LinkedIn: [`linkedin.com/in/alireza-mehdipour-8868686229`](https://www.linkedin.com/in/alireza-mehdipour-8868686229)

---

## 📄 License

MIT License — free to use, modify, and share.
