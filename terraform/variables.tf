variable "project" {
  description = "Project Name"
  type        = string
  default     = "talentplus"
}

variable "Owner" {
  description = "The owner of the resources"
  type        = string
  default     = ""
}

variable "name" {
  description = "the name of your stack, e.g. \"demo\""
  type        = string
  default     = "tplus-stack"
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
  default     = "prod"
}

# If access needs to be restricted externally
# Remove the default allow all ip range "0.0.0.0/0" and add the ips that should be allowed to access the alb
# e.g. 125.264.1.0/32, 145.32.67.98/32
# Multiple ip ranges can be specified by separating them with a comma
# e.g. ["125.264.1.0/32", "145.32.67.98/32"]
# An empty list will remove all ip ranges and block all external traffic e.g. []
# whitelisted_ips: ["0.0.0.0/0"]
# variable "whitelisted_ips" {
#   description = "The IP addresses that can access the ALB"
#   default     = ["0.0.0.0/0"]
#   type        = list(string)
# }

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "tplus-cluster"
}

variable "is_internal" {
  description = "Is the load balancer internal?"
  type        = bool
  default     = false
}

variable "subdomain" {
  description = "The subdomain name of the service"
  default     = "eks"
  type        = string
}

variable "domain_name" {
  description = "The domain name of the service"
  default     = "cgseerapps.com"
  type        = string
}

variable "registry_name" {
  description = "The name of the registry."
  default     = "talentplus"
  # default = ["frontend", "backend"]
}
