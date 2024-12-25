
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_a_id" {
  value = module.vpc.private_subnet_a_id
}

output "private_subnet_b_id" {
  value = module.vpc.private_subnet_b_id
}

output "bastion_sg_id" {
  value = module.security_groups.bastion_sg_id
}

output "private_sg_id" {
  value = module.security_groups.private_sg_id
}

output "web_sg_id" {
  value = module.security_groups.web_sg_id
}

output "s3_bucket_name" {
  value = module.s3_bucket.bucket_name
}
