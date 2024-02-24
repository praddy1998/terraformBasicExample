resource "aws_ecr_repository" "ecr_repository" {
  #name                 = "${var.project_family}/${var.environment}/${var.name}"
  for_each = toset(var.name)
  name                 = "${each.key}"
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = merge(
    var.additional_tags,
    {
      ManagedBy = "Terraform"
      Environment = "${var.environment}"
    }
  )
}

resource "aws_ecr_lifecycle_policy" "ecrpolicy" {
  for_each = toset(var.name)
  repository = aws_ecr_repository.ecr_repository[each.key].name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Keep last 10 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}