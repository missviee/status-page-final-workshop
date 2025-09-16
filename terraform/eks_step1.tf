module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access       = false
  cluster_endpoint_private_access      = true

  eks_managed_node_groups = {
    dr_nodes = {
      desired_size   = 2
      max_size       = 5
      min_size       = 1
      instance_types = ["t3.medium"]
    }
  }
}

resource "aws_security_group_rule" "bastion_to_eks" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = module.eks.cluster_security_group_id
}

resource "aws_iam_role_policy_attachment" "eks_worker_ecr" {
  role       = module.eks.eks_managed_node_groups["dr_nodes"].iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
