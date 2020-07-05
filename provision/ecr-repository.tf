resource "aws_ecr_repository" "nginx-repo" {
  name                 = "nginx"
  image_tag_mutability = "MUTABLE"
}

data "aws_ecr_repository" "nginx-repo" {
  name = aws_ecr_repository.nginx-repo.name
}