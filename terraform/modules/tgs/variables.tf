variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "sg_id" {
  description = "Security Group ID for the ALB"
  type        = string
}

variable "subnets" {
  description = "Subnets for the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the ALB resides"
  type        = string
}

variable "instance_id_jenkins" {
  description = "VPC ID where the ALB resides"
  type        = string
}

variable "instance_id_app" {
  description = "VPC ID where the ALB resides"
  type        = string
}

variable "alb_arn" {
  description = "VPC ID where the ALB resides"
}
