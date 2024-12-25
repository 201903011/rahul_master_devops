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
  my_ip  = "YOUR_IP/32" # my ip 
}

module "instances" {
  source             = "./modules/instances"
  ami_id             = "ami-12345678" # current AMI ID
  instance_type      = "t2.micro"
  public_subnet_a_id = module.vpc.public_subnet_a_id
  bastion_sg_id      = module.security_groups.bastion_sg_id
  web_sg_id          = module.security_groups.web_sg_id
  key_name           = "your-key-name" # current key pair name
}


module "alb" {
  source   = "./modules/alb"
  subnets  = [module.vpc.private_subnet_a_id, module.vpc.private_subnet_b_id]
  sg_id    = module.security_groups.web_sg_id
  alb_name = "app-alb"
}
