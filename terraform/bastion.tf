# Security Group for Bastion
resource "aws_security_group" "bastion_sg" {
  name        = "dr_bastion_sg"
  description = "Allow SSH from my local machine only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "79.181.174.149/32",
      "46.116.229.250/32"
    ]
  }

  ingress {
    description = "Port 8000 from my IP"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [
      "79.181.174.149/32",
      "46.116.229.250/32"
    ]
  }


  ingress {
    description = "Port 8000 from my IP"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [
      "79.181.174.149/32",
      "46.116.229.250/32"
    ]
  }




  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dr_bastion_sg"
  }
}


# Bastion EC2 instance
resource "aws_instance" "dr_bastion" {
  ami                         = "ami-0b09ffb6d8b58ca91" # Amazon Linux 2 (us-east-1)
  instance_type               = "t3.small"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = "rachel_key_home"

  tags = {
    Name = "dr_bastion"
  }
}
