resource "aws_ecs_service" "hobby-ecs-service" {
  	name                              = "hobby-ecs-service"
  	cluster                           = aws_ecs_cluster.hobby-ecs-cluster.id
	desired_count                     = 1
  	task_definition                   = aws_ecs_task_definition.hobby-projects.arn

	capacity_provider_strategy { 
    	base              = 0
    	capacity_provider = aws_ecs_capacity_provider.stingy.name
    	weight            = 1
    }

	deployment_controller {
    	type = "ECS"
    }

	deployment_maximum_percent         = 100
    deployment_minimum_healthy_percent = 50
}