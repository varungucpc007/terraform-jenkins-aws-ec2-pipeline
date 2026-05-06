variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI"
  default = "ami-03f4878755434977f"
}

variable "key_name" {
  description = "Existing AWS key pair"
  default     = "windows_bhagat_aarti"
}