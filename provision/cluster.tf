resource "aws_ecs_capacity_provider" "stingy" {
  name = "hobby_ecs_stingy"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs-autoscaling-group.arn

    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_cluster" "hobby-ecs-cluster" {
    name               = var.ecs_cluster
    capacity_providers = [aws_ecs_capacity_provider.stingy.name]

    default_capacity_provider_strategy {
        capacity_provider = aws_ecs_capacity_provider.stingy.name
        weight            = 1
    }
}