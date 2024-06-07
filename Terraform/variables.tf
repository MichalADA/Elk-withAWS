variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-0e001c9271cf7f3b9" # Aktualna AMI
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = "t2.medium" # Aktualny typ instancji
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "ELk-key"
}

variable "private_key_path" {
  description = "Path to the private key file"
  type        = string
  default     = "Elk-key.pem"
}
