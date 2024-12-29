resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_a_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.bastion_sg_id]
  associate_public_ip_address = true

  tags = {
    Name = "bastion"
  }
}

resource "aws_instance" "jenkins" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_a_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.web_sg_id]
  associate_public_ip_address = true

  tags = {
    Name = "jenkins"
  }
}

resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_b_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.web_sg_id]
  associate_public_ip_address = true

  tags = {
    Name = "app"
  }
}
