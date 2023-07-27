# run the command below to specify the path for configuration of the
# terraform state in S3 bucket with the DynamoDb table as the backend and encryption, locking enabled
# terraform init -backend-config=backend.hcl

module "vpc" {
  source = "./modules/vpc"
  #   second_octet             = var.second_octet
  #   no_of_availability_zones = var.no_of_availability_zones

}

module "dns" {
  source      = "./modules/dns"
  domain_name = var.domain_name
  subdomain   = var.subdomain
}

module "eks" {
  source           = "./modules/eks"
  project          = var.project
  eks_cluster_name = var.cluster_name
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.public_subnets
}

module "ecr" {
  source        = "./modules/ecr"
  project       = var.project
  registry_name = var.registry_name
}

module "eks-addons" {
  source          = "./modules/eksAddons"
  cluster_name    = module.eks.cluster_name
  cluster_version = module.eks.cluster_version
  domain_name     = module.dns.subdomain_name
}

# minikube start --nodes 2 --kubernetes-version=1.24.0
