module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = ["79.181.174.149/32"]

  eks_managed_node_groups = {
    dr_nodes = {
      desired_size   = 2
      max_size       = 5
      min_size       = 1
      instance_types = ["t3.medium"]
    }
  }
}

resource "aws_security_group_rule" "eks_api_access" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["79.181.174.149/32"]
  security_group_id = module.eks.cluster_security_group_id
}


