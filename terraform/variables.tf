variable "region" {
  default = "eu-north-1"
}

variable "project" {
  default = "ivolve"
}

variable "cluster_name" {
  default = "ivolve-eks"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "my_ip_cidr" {
  description = "Your public IP as x.x.x.x/32"
}

variable "ssh_public_key_path" {
  default = "~/.ssh/ivolve-key.pub"
}

variable "jenkins_instance_type" {
  default = "t3.small"
}

variable "node_instance_type" {
  default = "t3.small"
}

variable "ecr_repositories" {
  default = ["frontend", "auth-service", "roadmap-service"]
}
