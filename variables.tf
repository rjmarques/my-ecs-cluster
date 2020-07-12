## AWS account id 
variable "account_id" {
  description = "AWS Accout ID"
}

variable "region" {
  description = "AWS region"
  default     = "eu-west-2"
}

## Twitter account creds
variable "twitter_client_id" {
  description = "Twitter account client id used to connect to the Twitter API"
}

variable "twitter_client_secret" {
  description = "Twitter account client secret used to connect to the Twitter API"
}

## Postgres URL
variable "postgres_url" {
  description = "URL of the Postgres database that the instances can connect to"
}
