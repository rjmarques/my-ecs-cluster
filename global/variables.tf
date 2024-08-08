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
}

variable "region" {
  description = "AWS region"
}

variable "availability_zone" {
  description = "AWS Subnet Availablity Zone"
}

## Autoscale Config

variable "max_instance_size" {
  description = "Maximum number of instances in the cluster"
  default     = "1"
}

variable "min_instance_size" {
  description = "Minimum number of instances in the cluster"
  default     = "0"
}

## Various container definitions 
variable "container_definitions" {
  description = "The containers that will be part of the main task"
  type        = list(string)
  default     = []
}

variable "secrets_arns" {
  description = "The arns of various secrets that need to be loaded onto the ECS tasks"
  type        = list(string)
  default     = []
}

variable "static_website_files" {
  description = "The file paths of various static files that need to be uploaded to S3"
  type        = map(object({
    build_path = string
    files      = list(string) 
  }))
  default     = {}
}
