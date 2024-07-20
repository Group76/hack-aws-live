resource "aws_ecs_task_definition" "task-doctor_auth" {
  family                   = "doctor_auth"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = jsonencode([
    {
      name   = "doctor_auth"
      image  = "doctor-auth-ecr-repository:latest"
      cpu    = 256
      memory = 512
      networkMode = "awsvpc",
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-create-group": "true",
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_doctor_auth_api.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs/doctor-auth-api"
        }
      }
    }
  ])
}