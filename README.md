# Terraform Jenkins AWS EC2 Pipeline Project

## Project Overview

This project demonstrates an end-to-end Infrastructure as Code workflow using Terraform and Jenkins to provision an AWS EC2 instance automatically.

The pipeline pulls Terraform configuration from GitHub, initializes Terraform, validates the configuration, generates an execution plan, and provisions AWS infrastructure through Jenkins.

## Architecture

```text
Developer
   |
   v
GitHub Repository
   |
   v
Jenkins Pipeline
   |
   v
Terraform CLI
   |
   v
AWS Provider
   |
   v
AWS EC2 Instance
```

## Tech Stack

| Tool | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| Jenkins | CI/CD automation |
| GitHub | Source code repository |
| AWS EC2 | Cloud compute service |
| AWS IAM | Access and permission management |
| AWS CLI | Local AWS authentication and testing |

## Workflow

1. Terraform code is pushed to GitHub.
2. Jenkins checks out the repository.
3. Jenkins runs `terraform init`.
4. Jenkins validates the Terraform configuration.
5. Jenkins creates a Terraform plan.
6. Jenkins applies the plan.
7. AWS EC2 infrastructure is provisioned automatically.

## Project Structure

```text
.
├── Jenkinsfile
├── provider.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
└── README.md
```

| File | Description |
|---|---|
| `provider.tf` | AWS provider and Terraform provider configuration |
| `main.tf` | EC2 instance and related AWS resources |
| `variables.tf` | Input variables used by Terraform |
| `outputs.tf` | Output values such as instance ID and public IP |
| `terraform.tfvars.example` | Example variable values |
| `Jenkinsfile` | Jenkins CI/CD pipeline definition |

## Prerequisites

Install the following tools before running this project:

- Git
- Jenkins
- Terraform
- AWS CLI
- An AWS account
- IAM user or role with required permissions

Verify installations:

```bash
git --version
terraform version
aws --version
```

## AWS IAM Setup

Create an IAM user for Terraform automation.

For a demo project, attach these AWS managed policies:

- `AmazonEC2FullAccess`
- `AmazonVPCFullAccess`

For production use, prefer a custom least-privilege IAM policy that only allows the resources and actions required by this Terraform project.

After creating the IAM user, generate:

- Access Key ID
- Secret Access Key

Do not commit AWS access keys to GitHub.

## Configure AWS CLI Locally

Run:

```bash
aws configure
```

Enter:

```text
AWS Access Key ID: <your-access-key>
AWS Secret Access Key: <your-secret-key>
Default region name: ap-south-1
Default output format: json
```

Verify AWS authentication:

```bash
aws sts get-caller-identity
```

## Recommended Jenkins Credential Setup

In Jenkins, store AWS credentials securely instead of writing them directly in the Jenkinsfile.

Go to:

```text
Manage Jenkins -> Credentials -> System -> Global credentials -> Add Credentials
```

Create credentials:

| Field | Value |
|---|---|
| Kind | Username with password |
| ID | `aws-creds` |
| Username | AWS Access Key ID |
| Password | AWS Secret Access Key |

## Terraform Variables

Example `variables.tf`:

```hcl
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "terraform-jenkins-ec2"
}
```

Example `terraform.tfvars.example`:

```hcl
aws_region    = "ap-south-1"
ami_id        = "ami-xxxxxxxxxxxxxxxxx"
instance_type = "t2.micro"
instance_name = "terraform-jenkins-ec2"
```

Copy the example file before running locally:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Update `ami_id` with a valid AMI ID for your AWS region.

## Jenkins Pipeline

Example `Jenkinsfile`:

```groovy
pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Format Check') {
            steps {
                sh 'terraform fmt -check'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        success {
            echo 'EC2 infrastructure provisioned successfully.'
        }
        failure {
            echo 'Pipeline failed. Check Jenkins logs for details.'
        }
    }
}
```

If Jenkins is running on Windows, replace `sh` steps with `bat`:

```groovy
bat 'terraform init'
bat 'terraform validate'
bat 'terraform plan -out=tfplan'
bat 'terraform apply -auto-approve tfplan'
```

## How to Run Locally

Initialize Terraform:

```bash
terraform init
```

Format Terraform files:

```bash
terraform fmt
```

Validate configuration:

```bash
terraform validate
```

Preview infrastructure changes:

```bash
terraform plan
```

Apply infrastructure:

```bash
terraform apply
```

Approve when prompted.

## How to Run with Jenkins

1. Start Jenkins.
2. Create a new Pipeline job.
3. Connect the job to your GitHub repository.
4. Add AWS credentials in Jenkins with ID `aws-creds`.
5. Make sure Terraform is installed on the Jenkins machine.
6. Run the pipeline using **Build Now**.

## Expected Output

After successful execution, Terraform will create an EC2 instance and print outputs such as:

```text
instance_id = "i-xxxxxxxxxxxxxxxxx"
public_ip   = "x.x.x.x"
public_dns  = "ec2-x-x-x-x.ap-south-1.compute.amazonaws.com"
```

## Cleanup

To destroy all resources created by Terraform, run:

```bash
terraform destroy
```

In Jenkins, a separate destroy pipeline or parameterized destroy stage can be added for controlled cleanup.

Do not leave unused EC2 instances running because they may generate AWS charges.

## Security Best Practices

- Never commit AWS access keys to GitHub.
- Store credentials in Jenkins Credentials Manager.
- Use least-privilege IAM policies for production.
- Restrict Jenkins access to trusted users.
- Review the Terraform plan before applying changes.
- Use remote Terraform state for team environments.
- Enable state locking when using a remote backend.

## Recommended Remote Backend

For team or production usage, store Terraform state in S3 and use DynamoDB for state locking.

Example backend:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "ec2/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

Create the S3 bucket and DynamoDB table before enabling this backend.

## Troubleshooting

### AWS Authentication Failed

Check:

```bash
aws sts get-caller-identity
```

If it fails, verify the AWS access key, secret key, and region.

### Terraform Command Not Found

Install Terraform and add it to the system `PATH`.

Verify:

```bash
terraform version
```

### Invalid AMI ID

Use an AMI ID that exists in your selected AWS region.

Example:

```text
AMI IDs are region-specific. An AMI from us-east-1 will not work in ap-south-1.
```

### Permission Denied

Confirm that the IAM user has the required EC2 and VPC permissions.

For demo:

```text
AmazonEC2FullAccess
AmazonVPCFullAccess
```

### Terraform State Lock Issue

If using a remote backend, make sure the DynamoDB lock table exists and Jenkins has permission to access it.

## Conclusion

This project automates AWS EC2 provisioning using Terraform and Jenkins. It provides a practical CI/CD workflow for cloud infrastructure deployment and can be extended with remote state, approval gates, security groups, SSH key pairs, and multi-environment deployments.

