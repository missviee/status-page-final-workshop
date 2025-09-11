module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.26"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  manage_aws_auth = true

  node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 5
      min_capacity     = 1
      instance_types   = ["t3.medium"]
    }
  }

  create_oidc = true
}

data "aws_eks_cluster" "cluster" { name = module.eks.cluster_id }
data "aws_eks_cluster_auth" "cluster" { name = module.eks.cluster_id }

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
