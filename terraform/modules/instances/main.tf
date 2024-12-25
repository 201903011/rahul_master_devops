resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_a_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.bastion_sg_id]
  tags = {
    Name = "bastion"
  }
}

resource "aws_instance" "jenkins" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_a_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.private_sg_id]
  tags = {
    Name = "jenkins"
  }
}

resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_b_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.private_sg_id]
  tags = {
    Name = "app"
  }
}
