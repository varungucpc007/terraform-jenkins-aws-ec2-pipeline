# terraform-jenkins-aws-ec2-pipeline

# 🚀 Terraform + Jenkins AWS EC2 Pipeline

## 📌 Project Overview

This project demonstrates Infrastructure as Code (IaC) using Terraform integrated with Jenkins CI/CD to automate AWS EC2 provisioning.

## 🛠️ Tech Stack

* Terraform
* Jenkins (Local Setup)
* AWS EC2
* GitHub

## ⚙️ Workflow

1. Code pushed to GitHub
2. Jenkins pulls repository
3. Terraform initializes and plans
4. EC2 instance is provisioned automatically

## 📁 Project Structure

* main.tf → EC2 resource
* variables.tf → Input variables
* outputs.tf → Output values
* provider.tf → AWS provider config
* Jenkinsfile → CI/CD pipeline

## ▶️ How to Run

1. Configure AWS CLI
2. Start Jenkins locally
3. Create pipeline job
4. Connect GitHub repo
5. Click "Build Now"

## 🧹 Cleanup

Run:
terraform destroy
