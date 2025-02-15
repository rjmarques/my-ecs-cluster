resource "aws_launch_configuration" "ecs-launch-configuration" {
  name_prefix          = "hobby-ecs-launch-configuration"
  # image_id             = "ami-050d140dbea0078a5" offical AWS 30GB
  image_id             = "ami-0d2b5e8f794d68452"
  instance_type        = "t3a.nano"
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    iops                  = 3000
    throughput            = 125
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  security_groups             = [aws_security_group.ecs_security_group.id]
  associate_public_ip_address = "true"
  key_name                    = var.ecs_key_pair_name
  user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${var.ecs_cluster} >> /etc/ecs/ecs.config
                                  echo ECS_ENABLE_AWSLOGS_EXECUTIONROLE_OVERRIDE=true >> /etc/ecs/ecs.config
                                  EOF
}
