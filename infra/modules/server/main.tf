# Service

resource "aws_ecs_cluster" "my_service_cluster" {
  name = "my-service"
}

resource "aws_ecs_task_definition" "my_service_definition" {
  family = "my-service"

  container_definitions = jsonencode([
    {
      name = "main"

      image     = var.server_image
      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])

  cpu    = 256
  memory = 512
}

resource "aws_ecs_service" "my_service" {
  name = "my-service"

  task_definition = aws_ecs_task_definition.my_service_definition.id

  cluster       = aws_ecs_cluster.my_service_cluster.id
  desired_count = 1
}


# Compute

resource "aws_launch_configuration" "my_service_launch_config" {
  image_id = "ami-0a4cbf3bd47ef1bc9" # Amazon Linux 2 (Version: 73), from us-east-2

  iam_instance_profile = aws_iam_instance_profile.server_profile.arn
  security_groups      = [aws_security_group.server_sg.id]

  instance_type = "t2.micro"
  user_data     = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.my_service_cluster.name} >> /etc/ecs/ecs.config"

  associate_public_ip_address = true
}

resource "aws_autoscaling_group" "my_service_asg" {
  name = "my-service"

  vpc_zone_identifier = [var.subnet]

  launch_configuration = aws_launch_configuration.my_service_launch_config.name

  max_size         = 1
  min_size         = 1
  desired_capacity = 1

  tag {
    key   = "Project"
    value = var.project_name

    propagate_at_launch = true
  }
}
