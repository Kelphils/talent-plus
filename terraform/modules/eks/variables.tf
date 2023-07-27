variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "The IDs of the private subnets"
  type        = list(string)
}

variable "project" {
  description = "Project Name"
  type        = string
}
