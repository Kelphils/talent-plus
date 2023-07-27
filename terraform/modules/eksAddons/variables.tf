variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "cluster_version" {
  description = "The Kubernetes server version of the cluster"
  type        = string
}

variable "domain_name" {
  description = "The domain name of the eks service"
  type        = string
}

