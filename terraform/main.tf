provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr              = "10.0.0.0/16"
  private_subnet_a_cidr = "10.0.1.0/24"
  private_subnet_b_cidr = "10.0.2.0/24"
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
  my_ip  = "YOUR_IP/32"
}

module "instances" {
  source              = "./modules/instances"
  private_subnet_a_id = module.vpc.private_subnet_a_id
  private_subnet_b_id = module.vpc.private_subnet_b_id
  bastion_sg_id       = module.security_groups.bastion_sg_id
  private_sg_id       = module.security_groups.private_sg_id
  key_name            = "MyKeyPair"
  ami_id              = "ami-0abcdef1234567890"
}

module "alb" {
  source   = "./modules/alb"
  subnets  = [module.vpc.private_subnet_a_id, module.vpc.private_subnet_b_id]
  sg_id    = module.security_groups.web_sg_id
  alb_name = "app-alb"
}
