resource "aws_ecs_task_definition" "hobby-projects" {
  family             = "hobby-definition"
  execution_role_arn = aws_iam_role.ecs-task-execution-role.arn

  # joins multiple container definitions under 1 array 
  container_definitions = format("[%s]", join(",", var.container_definitions))
}
