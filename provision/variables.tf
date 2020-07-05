## Main creds for AWS connection 
variable "ecs_cluster" {
  description = "ECS cluster name"
  default     = "hobby-cluster"
}

variable "account_id" {
  description = "AWS Accout ID"
}

variable "ecs_key_pair_name" {
  description = "EC2 instance key pair name"
  default     = "ecs-cluster-key"
}

variable "region" {
  description = "AWS region"
  default     = "eu-west-2"
}

variable "availability_zone" {
  description = "AWS Subnet Availablity Zone"
  default     = "eu-west-2a"
}

## Autoscale Config

variable "max_instance_size" {
  description = "Maximum number of instances in the cluster"
  default     = "2"
}

variable "min_instance_size" {
  description = "Minimum number of instances in the cluster"
  default     = "0"
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