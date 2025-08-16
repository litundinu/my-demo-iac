resource "aws_ecr_repository" "app" {
  name                 = "${var.name_prefix}-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Expire untagged images after 7 days",
        selection    = { tagStatus = "untagged", countType = "sinceImagePushed", countUnit = "days", countNumber = 7 },
        action       = { type = "expire" }
      },
      {
        rulePriority = 2,
        description  = "Keep last 30 images",
        selection    = { tagStatus = "any", countType = "imageCountMoreThan", countNumber = 30 },
        action       = { type = "expire" }
      }
    ]
  })
}
