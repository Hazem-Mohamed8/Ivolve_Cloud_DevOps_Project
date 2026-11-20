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
