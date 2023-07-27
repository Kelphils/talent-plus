output "repository_url" {
  description = "The URL of the repository."
  # value       = [for repo in aws_ecr_repository.repository : repo.repository_url]
  value = aws_ecr_repository.repository.repository_url
}

output "repository_arn" {
  description = "The ARN of the repository."
  # value       = [for repo in aws_ecr_repository.repository : repo.arn]
  value = aws_ecr_repository.repository.arn
}

output "repo_name" {
  description = "The Name of the repository."
  # value       = [for repo in aws_ecr_repository.repository : repo.name]
  value = aws_ecr_repository.repository.name
}
