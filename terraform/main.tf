module "network" {
  source               = "./modules/network"
  name                 = var.project
  cluster_name         = var.cluster_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "ecr" {
  source       = "./modules/ecr"
  project      = var.project
  repositories = var.ecr_repositories
}

module "server" {
  source        = "./modules/server"
  name          = var.project
  vpc_id        = module.network.vpc_id
  subnet_id     = module.network.public_subnet_ids[0]
  instance_type = var.jenkins_instance_type
  my_ip_cidr    = var.my_ip_cidr
  public_key    = file(pathexpand(var.ssh_public_key_path))
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  private_subnet_ids = module.network.private_subnet_ids
  public_subnet_ids  = module.network.public_subnet_ids
  node_instance_type = var.node_instance_type
}

# CI runner -> EKS API (the runner resolves the endpoint to the private ENIs inside the VPC)
resource "aws_vpc_security_group_ingress_rule" "runner_to_eks_api" {
  security_group_id            = module.eks.cluster_security_group_id
  referenced_security_group_id = module.server.security_group_id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  description                  = "GitHub Actions runner to EKS API"
}

# kubectl/helm access for the pipeline user
data "aws_iam_user" "ci" {
  user_name = "github-actions-ecr"
}

resource "aws_eks_access_entry" "ci" {
  cluster_name  = module.eks.cluster_name
  principal_arn = data.aws_iam_user.ci.arn
}

resource "aws_eks_access_policy_association" "ci" {
  cluster_name  = module.eks.cluster_name
  principal_arn = data.aws_iam_user.ci.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.ci]
}
