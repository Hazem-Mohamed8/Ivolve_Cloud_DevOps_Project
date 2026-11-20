output "jenkins_public_ip" {
  value = module.server.public_ip
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}

output "vpc_id" {
  value = module.network.vpc_id
}
