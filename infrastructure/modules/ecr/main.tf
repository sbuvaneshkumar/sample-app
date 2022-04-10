resource "aws_ecr_repository" "ecr_repo" {
  name = var.ecr_repo_name 
}

resource "aws_ecr_lifecycle_policy" "ecr_repo_policy" {
  repository = aws_ecr_repository.ecr_repo.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keeps last 15 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 15
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

output "ecr_repo_url" {
  value = aws_ecr_repository.ecr_repo.repository_url
}
