# erc repositories
output "ecs_cluster" {
  value = module.global.ecs_cluster
}

output "nginx_ecr_repository_url" {
  value = module.nginx.ecr_repository_url
}

output "personal_website_ecr_repository_url" {
  value = module.personal-website.ecr_repository_url
}

output "sotd_ecr_repository_url" {
  value = module.sotd.ecr_repository_url
}

