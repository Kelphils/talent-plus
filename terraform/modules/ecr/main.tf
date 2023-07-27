locals {
  terratag = { Name = "${var.project}-Ecr-Repo", ProjectName = var.project }
}

resource "aws_ecr_lifecycle_policy" "main" {
  # for_each   = { for idx, repo in aws_ecr_repository.repository : idx => repo }
  # repository = each.value.name
  repository = aws_ecr_repository.repository.id
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}

resource "aws_ecr_repository" "repository" {
  # using for each function
  #   for_each             = { for idx, name in var.registry_name : idx => name }
  # name                 = "${each.value}-${var.type}-registry"
  # using count
  # count = length(var.registry_name)
  # name  = "tplus-${var.registry_name[count.index]}"
  name                 = var.registry_name
  image_tag_mutability = "MUTABLE"
  force_delete         = var.repository_force_delete

  tags = local.terratag


  image_scanning_configuration {
    scan_on_push = true
  }
}

# resource "aws_ecrpublic_repository" "repository" {
#   provider        = aws.us_east_1
#   repository_name = var.registry_name
#   tags            = local.terratag

# }

# provider "aws" {
#   alias  = "us_east_1"
#   region = "us-east-1"
# }
