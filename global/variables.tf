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

## Various container defintions 
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
