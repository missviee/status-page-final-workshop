variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "dr_statuspage_cluster"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_allocated_storage" {
  type    = number
  default = 30
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.medium"
}

variable "ecr_repo_name" {
  type    = string
  default = "dr_repo_statuspage"
}

variable "env" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}
