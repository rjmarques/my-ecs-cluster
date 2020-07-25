output "ecr_repository_url" {
  value = data.aws_ecr_repository.nginx-repo.repository_url
}

output "container_definition" {
  value = templatefile("${path.module}/container_definition.json", {
    repository_url = data.aws_ecr_repository.nginx-repo.repository_url
  })
}

output "secrets_arns" {
  value = []
}
