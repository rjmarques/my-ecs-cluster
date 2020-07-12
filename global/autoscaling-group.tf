resource "aws_autoscaling_group" "ecs-autoscaling-group" {
    name                        = "hobby-ecs-autoscaling-group"
    max_size                    = var.max_instance_size
    min_size                    = var.min_instance_size
    health_check_type           = "EC2"
    vpc_zone_identifier         = [aws_default_subnet.default.id]
    launch_configuration        = aws_launch_configuration.ecs-launch-configuration.name
    tag {
        key                     = "Name"
        value                   = "hobby-ecs-instance"
        propagate_at_launch     = true
    }
}