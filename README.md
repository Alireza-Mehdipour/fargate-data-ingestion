# Fargate Data Ingestion

**FastAPI on AWS ECS/Fargate — Terraform, Docker, ALB**

A containerised FastAPI service deployed on **AWS Fargate** using **Terraform**, **ECS**, **ECR**, **ALB**, and **Docker**.
Built to demonstrate containerization, Infrastructure as Code, cloud architecture, and secure, scalable deployment patterns.

---

## Project Overview

Key features include:

- FastAPI application packaged in a lightweight Docker image  
- IAM task execution role with scoped permissions
- Application Load Balancer with health checks and routing  
- Private ECR repository for image storage  
- Modular Terraform structure for clean, reusable IaC  
- CloudWatch logging for observability  
- Provider versions pinned via .terraform.lock.hcl

---

## 📸 Application Screenshot


<img width="1396" height="757" alt="screenshot png" src="https://github.com/user-attachments/assets/734c4341-5bcd-4f7d-ae4d-892a709e0928" />


The screenshot above shows the running application. The environment has been
destroyed to avoid ongoing cost, and can be recreated with `terraform apply`.

---

## Architecture

**AWS Services Used:**

- **ECS Fargate** --> serverless container compute  
- **ECR** --> container registry  
- **ALB** --> traffic routing and health checks  
- **VPC + Subnets** --> networking foundation  
- **CloudWatch Logs** --> application logging  
- **IAM** --> secure role‑based access  

**High‑Level Flow:**

1. Docker image is built locally and pushed to ECR  
2. Terraform provisions ECS cluster, task definition, service, ALB, and networking  
3. ECS Fargate pulls the image and runs the FastAPI container  
4. ALB exposes the application publicly  
5. Logs stream to CloudWatch for monitoring  

---

## Repository Structure

```
fargate-data-ingestion/
├── app/                      # FastAPI application and container definition
│   ├── main.py               # API entry point
│   ├── index.html            # Served landing page
│   ├── requirements.txt      # Python dependencies
│   └── Dockerfile            # Docker image definition
│
├── infra/                    # Terraform infrastructure as code
│   ├── modules/              # Reusable modules (networking, ECS, ALB, ECR)
│   ├── main.tf               # Root configuration
│   ├── variables.tf          # Input variables
│   ├── outputs.tf            # Outputs (ALB URL, ECR repository)
│   └── .terraform.lock.hcl   # Provider version lock file
│
├── .gitignore
├── LICENSE                   # MIT License
└── README.md
```

---

## Local Development

Build and run the FastAPI app locally:

```bash
docker build -t fargate-data-ingestion:v1.0.3 ./app
docker run -p 8000:8000 fargate-data-ingestion:v1.0.3
```

Visit the application locally:

```
http://localhost:8000
```

---

## Deployment Workflow (Terraform + ECR)

### 1. Build the Docker image
```bash
docker build -t fargate-data-ingestion:v1.0.3 ./app
```

### 2. Authenticate Docker to AWS ECR
```bash
aws ecr get-login-password --region ap-southeast-2 \
  | docker login --username AWS \
  --password-stdin <ACCOUNT_ID>.dkr.ecr.ap-southeast-2.amazonaws.com
```

### 3. Tag the image for ECR
```bash
docker tag fargate-data-ingestion:v1.0.3 \
  <ACCOUNT_ID>.dkr.ecr.ap-southeast-2.amazonaws.com/fargate-data-ingestion:v1.0.3
```

### 4. Push the image to ECR
```bash
docker push \
  <ACCOUNT_ID>.dkr.ecr.ap-southeast-2.amazonaws.com/fargate-data-ingestion:v1.0.3
```

### 5. Deploy infrastructure with Terraform
```bash
cd infra
terraform init
terraform plan
terraform apply
```

### 6. ECS Fargate automatically pulls:
```
<ACCOUNT_ID>.dkr.ecr.ap-southeast-2.amazonaws.com/fargate-data-ingestion:v1.0.3
```

---

## Terraform Example (Task Definition Snippet)

```hcl
container_definitions = jsonencode([
  {
    name      = "fastapi-app"
    image     = "<ACCOUNT_ID>.dkr.ecr.ap-southeast-2.amazonaws.com/fargate-data-ingestion:v1.0.3"
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

- Deploying containerised workloads with Infrastructure as Code 
- Ability to design and deploy containerized applications  
- Proficiency with Terraform and AWS services  
- Clean, modular infrastructure with reusable Terraform modules 
- Strong documentation and engineering communication  

---

## 👤 Author

**Alireza Mehdipour**  
Cloud & DevOps Engineer  
LinkedIn: [`linkedin.com/in/ali-mehdipour-886686229`](https://www.linkedin.com/in/ali-mehdipour-886686229/)

---

## 📄 License

MIT License — free to use, modify, and share.
