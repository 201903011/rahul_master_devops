# variables.tf

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "test-bucket"
}


variable "region" {
  description = "The AWS region to use"
  type        = string
  default     = "us-east-1"
}
