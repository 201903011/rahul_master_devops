variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "public_subnet_a_id" {
  description = "Public Subnet A ID"
  type        = string
}

variable "private_subnet_a_id" {
  description = "Public Subnet A ID"
  type        = string
}

variable "private_subnet_b_id" {
  description = "Public Subnet A ID"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security Group ID for bastion host"
  type        = string
}

variable "web_sg_id" {
  description = "Security Group ID for Jenkins and App"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}
