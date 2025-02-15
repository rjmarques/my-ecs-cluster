resource "aws_ecs_task_definition" "hobby-projects" {
  family             = "hobby-definition"
  execution_role_arn = aws_iam_role.ecs-task-execution-role.arn

  # joins multiple container definitions under 1 array 
  container_definitions = format("[%s]", join(",", var.container_definitions))

  # where letsencrypt resources (e.g., accounts, certs, keys) are stored
  volume {
    name = "letsencrypt"

    docker_volume_configuration {
      scope         = "shared"
      autoprovision = true
      driver        = "local"
    }
  }

  # where cached resources (e.g., html, js, image) are stored
  volume {
    name = "cache"

    docker_volume_configuration {
      scope         = "shared"
      autoprovision = true
      driver        = "local"
    }
  }
}
