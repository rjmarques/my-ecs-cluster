# erc repositories
output "nginx_ecr_repository_url" {
  value = module.global.ecr_repository_url
}

output "sotd_ecr_repository_url" {
  value = module.sotd.ecr_repository_url
}

