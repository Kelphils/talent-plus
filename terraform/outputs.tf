output "domain_name" {
  value       = module.dns.subdomain_name
  description = "The domain name of the service"
}

output "ecr_repo_urls" {
  value       = module.ecr.repository_url
  description = "The URL of the repository."
}

output "kubectl_config" {
  value       = module.eks.configure_kubectl
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
}
