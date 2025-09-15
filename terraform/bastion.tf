resource "aws_security_group" "bastion_sg" {
  name        = "dr_bastion_sg"
  description = "Allow SSH from my local machine only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [chomp(data.http.myip.body) + "/32"]
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

# Get your public IP dynamically
data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

resource "aws_instance" "dr_bastion" {
  ami                         = "ami-0c7217cdde317cfec" # Amazon Linux 2 (us-east-1)
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = "rachel_duvie_key"

  tags = {
    Name = "dr_bastion"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -aG docker ec2-user

              # Install AWS CLI v2
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install

              # Install kubectl (גרסה 1.30, כמו ב־EKS שלך)
              curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.0/2024-07-05/bin/linux/amd64/kubectl
              chmod +x ./kubectl
              mv ./kubectl /usr/local/bin/

              # Install Helm
              curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
              EOF
}


