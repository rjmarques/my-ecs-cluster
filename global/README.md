## global module

This is the Terraform module that provisions most of the resources required to have my ECS cluster up and running. In particular, it takes care of all the IAM roles, EC2 launch configuration, cluster definiton and so on.

To achieve this result, it expects to receive the following parameters:

- `account_id` - the AWS account id
- `ecs_key_pair_name` - the SSH key that can be used to access the cluster's instances
- `region` - AWS region
- `availability_zone` - AZ inside the region
- `container_definitions` - A string array containing the various container definitions (as JSON) that will comprise the ECS Task
- `secrets_arns` - Secrets that the Tasks might need to access and that need to be exposed via IAM roles

Note that I am stingy 🦆💰 and as a result I set my ECS Capacity Provider to at most have 1 running EC2 instance. Matter of fact, this whole infrastructure layout is built around only having 1 EC2 instance. Otherwise I would have moved NGINX out of the main Task.

Saying this, I noticed that the first time the ECS Service was created, ECS tended to create 2 EC2s but after 10 minutes or so terminated one of them because no tasks were running on it.
