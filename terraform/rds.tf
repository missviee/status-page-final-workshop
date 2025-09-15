resource "aws_db_subnet_group" "statuspage" {
  name       = "statuspage-db-subnet-group"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_security_group" "db_sg" {
  name   = "dr-statuspage-db-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    # Replace below with correct security group for EKS nodes if needed
    cidr_blocks = ["10.0.11.0/24", "10.0.12.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "statuspage" {
  identifier             = "dr-statuspage-db"
  engine                 = "postgres"
  engine_version         = "17.4"
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  db_name                = "dr_db_admin_statuspage"
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = false
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.statuspage.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

output "rds_endpoint" {
  value = aws_db_instance.statuspage.address
}

