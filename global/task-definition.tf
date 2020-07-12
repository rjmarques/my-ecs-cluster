resource "aws_ecs_task_definition" "hobby-projects" {
  family             = "hobby-definition"
  execution_role_arn = aws_iam_role.ecs-task-execution-role.arn

  # joins multiple container definitions under 1 array 
  container_definitions = format(
    "[%s]",
    join(",", concat(
      [
        templatefile("${path.module}/container_definition.json", {
          repository_url = aws_ecr_repository.nginx-repo.repository_url
        })
      ],
      var.container_definitions
      )
    )
  )
}
