# Final Workshop Status-Page App

---

## 🌐 Project Overview
The **Status-Page App** is a cloud-native application deployed on **AWS** using **Terraform, Kubernetes (EKS), and GitHub Actions**.  
It demonstrates a production-grade setup including networking, security, monitoring, CI/CD pipelines, and database integration.

**Live URLs:**
- Application: [app.drstatuspage.click](https://app.drstatuspage.click/)
- Grafana: [grafana.drstatuspage.click](https://grafana.drstatuspage.click/)
- Prometheus: [prometheus.drstatuspage.click](https://prometheus.drstatuspage.click/)

---

## 🏛 Architecture
![Architecture Diagram](images/Architecture.jpg)


**Flow:**
1. **Users & DNS** → Route53 → ALB  
2. **ALB (Application Load Balancer)** → SSL/TLS termination → Ingress  
3. **EKS Cluster** → dr-statuspage pods, Redis StatefulSet, Monitoring stack  
4. **RDS Postgres** → Secure data storage (private subnet)  
5. **Bastion Host** → SSH access to private resources (EKS + RDS)  
6. **S3 Bucket** → Static assets (global service)  
7. **CI/CD (GitHub Actions)** → Builds and pushes images, deploys manually via Git Bash
 

---

## 💵 Monthly Cost Breakdown
**Budget:** $300 / month  
> 🛠 Note: We only ran the full infrastructure after Terraform was successfully applied. 
> The remaining days prior were spent preparing and correcting the configuration files, 
> so the actual costs reflect only the active usage period.
**Actual estimated costs:**

| Resource             | Daily Avg (USD) | Weekly (7d) | Monthly (30d) |
|----------------------|----------------|------------|---------------|
| CloudWatch Logs      | 0.46           | 3.25       | 13.93         |
| EBS gp3              | 0.02           | 0.13       | 0.55          |
| EC2 t3.small         | 0.43           | 2.98       | 12.79         |
| EKS Extended Support | 10.25          | 71.75      | 307.50        |
| EKS Per Cluster      | 2.05           | 14.35      | 61.50         |
| KMS Keys             | 0.03           | 0.20       | 0.85          |
| NAT Gateway Bytes    | 0.05           | 0.35       | 1.52          |
| NAT Gateway Hours    | 0.92           | 6.46       | 27.68         |
| RDS GP2-Storage      | 0.10           | 0.69       | 2.95          |
| RDS db.t3.medium     | 1.48           | 10.33      | 44.28         |
| Route53 + 4 CNAMEs   | 0.10           | 0.70       | 3.00          |
| **TOTAL**            | 15.89          | 111.19     | 476.55        |

> ⚠️ Over budget (mainly due to EKS Extended Support + NAT Gateway)
> 

---

## ⚙ Technology Choices

**Terraform (IaC)**  
✅ Infrastructure as Code, repeatable and consistent  
⚠️ Requires planning to avoid state conflicts  

**Kubernetes (EKS)**  
✅ Industry-standard orchestration  
✅ Private subnets = strong security  
⚠️ Higher costs and complexity  

**CI/CD (GitHub Actions)**  
✅ Automated CI (build & push to ECR)  
✅ Easy setup compared to Jenkins  
⚠️ Manual CD due to private EKS cluster  

**Monitoring Stack (Prometheus, Grafana, Loki)**  
✅ Full observability (metrics + logs)  
✅ Grafana dashboards secured with HTTPS & password  

**Trade-offs:**  
- Costly (EKS + NAT + RDS dominate budget)  
- Redis requires extra setup for HA  
- Dependency on AWS managed services  

---

## 🔑 Key Challenges

1. **Running the App in the Cluster** – Misconfigurations & Ingress issues slowed us down  
2. **Security vs Deployability** – Private EKS improved security but blocked full CD automation  
3. **Permission Barriers** – Limited IAM permissions delayed setup  

---

## 🛠 Key Components

- **Route53:** Domain, DNS, subdomain routing  
- **ALB + Ingress:** HTTPS termination, secure routing  
- **EKS Cluster:** Runs application pods, Redis, monitoring stack  
- **RDS (Postgres):** Secure data persistence (private subnet)  
- **Redis StatefulSet:** In-memory cache with PVC on EBS  
- **S3 Bucket:** Static asset storage (global service)  
- **Bastion Host:** Controlled SSH access  
- **GitHub Actions CI/CD:** Automated builds & manual CD  

---

## 🚀 Improvements If We Had More Time
- Add **CI/CD testing stage**  
- Implement **VPN/Direct Connect** for secure automated CD  
- Automate **Terraform validation** in CI/CD  

---

## 📌 Insights & Learnings
- **GitHub Actions is easier than Jenkins** for small projects  
- Learned to balance **security vs automation** in CI/CD  
- Hands-on experience with **Terraform + Kubernetes + AWS**  
- Networking & IAM permissions are often bigger blockers than code  
- Communication & teamwork matter; navigating a **language barrier** taught patience and precision  

---

### Created by Duvie, 2025
