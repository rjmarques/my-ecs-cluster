terraform {
  backend "pg" {
  }
}

module global {
  source = "./global"

  account_id = var.account_id
  region     = var.region

  container_definitions = [
    module.nginx.container_definition,
    module.sotd.container_definition
  ]

  secrets_arns = concat(
    module.nginx.secrets_arns,
    module.sotd.secrets_arns
  )
}

module nginx {
  source = "./nginx/aws"

  region = var.region
}

module sotd {
  source = "git@github.com:rjmarques/something-of-the-day//terraform/aws?ref=terraform-module"

  region                = var.region
  twitter_client_id     = var.twitter_client_id
  twitter_client_secret = var.twitter_client_secret
  postgres_url          = var.postgres_url
}
