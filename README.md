🚀 Terraform + Jenkins AWS EC2 Pipeline

📌 Project Overview

This project demonstrates Infrastructure as Code (IaC) using Terraform integrated with Jenkins CI/CD to automate AWS EC2 provisioning.

🛠️ Tech Stack
Terraform
Jenkins (Local Setup)
AWS EC2


⚙️ Workflow
Code pushed to GitHub
Jenkins pulls repository
Terraform initializes and plans
EC2 instance is provisioned automatically


🔐 AWS IAM Setup (Important)
Before running the project, you need to configure AWS access:
Create two IAM users in Amazon Web Services (AWS)
Attach the following permissions:
AmazonEC2FullAccess
AmazonVPCFullAccess
Generate Access Key and Secret Key for the IAM user


💻 Configure AWS CLI
Run the following command in your local terminal:
aws configure
Then provide:
AWS Access Key ID: <your-access-key>
AWS Secret Access Key: <your-secret-key>
Default region name: <your-region> (e.g., ap-south-1)
Default output format: json


📁 Project Structure
main.tf → EC2 resource
variables.tf → Input variables
outputs.tf → Output values
provider.tf → AWS provider config
Jenkinsfile → CI/CD pipeline


▶️ How to Run
Configure AWS CLI (as shown above)
Start Jenkins locally
Create pipeline job
Connect GitHub repo
Click "Build Now"


🧹 Cleanup
Run:
terraform destroy
