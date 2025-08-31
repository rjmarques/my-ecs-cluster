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
    module.sotd.container_definition
  ]

  secrets_arns = concat(
    module.nginx.secrets_arns,
    module.sotd.secrets_arns
  )

  static_website_files = {
    "${module.solar.target_name}" = {
      build_path = module.solar.build_path
      files = module.solar.static_files
    },
    "${module.webasm.target_name}" = {
      build_path = module.webasm.build_path
      files = module.webasm.static_files
    }
  }
}

module "nginx" {
  source = "./nginx/aws"

  region = var.region
}

# Below are my app modules. If you use different apps they should be defined here instead.

module "sotd" {
  source = "git@github.com:rjmarques/something-of-the-day//terraform/aws"

  region                = var.region
  twitter_client_id     = var.twitter_client_id
  twitter_client_secret = var.twitter_client_secret
  postgres_url          = var.postgres_url
}

# These modules are static websites that need to be uploaded to S3

module "solar" {
  source = "git@github.com:rjmarques/SolarSystem"
}

module "webasm" {
  source = "git@github.com:rjmarques/webasm-mandelbrot"
}
