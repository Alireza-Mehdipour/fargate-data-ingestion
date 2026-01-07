# 🚀 Fargate Data Ingestion Demo  
A fully containerized FastAPI application deployed on **AWS Fargate** using **Terraform**, **ECR**, **ECS**, and an **Application Load Balancer**.

This project demonstrates a clean, production‑ready deployment pipeline suitable for DevOps, Cloud, and Platform Engineering roles.

---

## 🌐 Architecture Overview

The stack includes:

- **FastAPI** application (Python)
- **Docker** containerization
- **Amazon ECR** for image storage
- **Amazon ECS (Fargate)** for serverless container execution
- **Application Load Balancer (ALB)** for public access
- **Terraform** for full IaC provisioning
- **CloudWatch Logs** for observability

The deployment is fully automated and reproducible.

---

## 🧱 Infrastructure Components

### **1. ECR**
Stores versioned Docker images (`v1.0.0`, `v1.0.1`, etc.).

### **2. ECS Cluster**
Runs the FastAPI container using Fargate.

### **3. Task Definition**
Defines CPU, memory, networking, and the container image.

### **4. ECS Service**
Ensures the task stays running and integrates with the ALB.

### **5. Application Load Balancer**
Provides a public endpoint and health checks.

### **6. Security Groups**
- ALB: allows inbound HTTP (80)
- ECS Tasks: only accepts traffic from ALB

---

## 📦 Deployment Workflow

### **1. Build and push a versioned image**
```bash
docker build -t fargate-demo .
docker tag fargate-demo:latest <ACCOUNT_ID>.dkr.ecr.ap-southeast-2.amazonaws.com/fargate-demo:v1.0.1
docker push <ACCOUNT_ID>.dkr.ecr.ap-southeast-2.amazonaws.com/fargate-demo:v1.0.1