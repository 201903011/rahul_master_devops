# modules/s3_bucket/main.tf

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name


  tags = {
    Name        = "my-bucket-1234eusewew"
    Environment = "Dev"
  }
}

