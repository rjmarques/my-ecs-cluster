resource "aws_ecs_task_definition" "hobby-projects" {
    family                = "hobby-definition"
    execution_role_arn    = aws_iam_role.ecs-task-execution-role.arn
    container_definitions = <<DEFINITION
[
  {
    "name": "nginx",
    "image": "${aws_ecr_repository.nginx-repo.repository_url}:latest",
    "memory": 128,
    "cpu": 256,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "protocol": "tcp"
      }
    ]
  }
]
DEFINITION
}