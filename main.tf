terraform {
  backend "s3" {
    bucket  = "ricardomarq-hobby-terraform-state"
    encrypt = true
    key     = "terraform.tfstate"
    region  = "eu-west-2"
    profile = "hobby-projects"
  }
}

module "global" {
  source = "./global"

  account_id        = var.account_id
  availability_zone = var.availability_zone
  region            = var.region
  ecs_key_pair_name = var.ecs_key_pair_name

  container_definitions = [
    module.nginx.container_definition,
    module.personal-website.container_definition,
    module.sotd.container_definition
  ]

  secrets_arns = concat(
    module.nginx.secrets_arns,
    module.personal-website.secrets_arns,
    module.sotd.secrets_arns
  )
}

module "nginx" {
  source = "./nginx/aws"

  region = var.region
}

# Below are my app modules. If you use different apps they should be defined here instead.

module "personal-website" {
  source = "git@github.com:rjmarques/personal-website//terraform/aws"

  region           = var.region
  recaptcha_secret = var.recaptcha_secret
  smtp_host        = var.smtp_host
  smtp_user        = var.smtp_user
  smtp_password    = var.smtp_password
  contact_email    = var.contact_email
}

module "sotd" {
  source = "git@github.com:rjmarques/something-of-the-day//terraform/aws"

  region                = var.region
  twitter_client_id     = var.twitter_client_id
  twitter_client_secret = var.twitter_client_secret
  postgres_url          = var.postgres_url
}
