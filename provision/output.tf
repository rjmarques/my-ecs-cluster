output "ecr_repository_url" {
  value = data.aws_ecr_repository.nginx-repo.repository_url
}