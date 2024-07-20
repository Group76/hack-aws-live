resource "aws_ecs_service" "patient_auth-service" {
  name            = "patient_auth"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task-patient_auth.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  health_check_grace_period_seconds = 240

  network_configuration {
    security_groups = [aws_security_group.ecs_task.id]
    subnets         = aws_subnet.private.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.patient_auth.id
    container_name   = aws_ecs_task_definition.task-patient_auth.family
    container_port   = 8080
  }

   depends_on = [
    aws_cloudwatch_log_group.ecs_patient_auth_api,
    aws_cloudwatch_log_stream.ecs_patient_auth_api,
    aws_lb_target_group.patient_auth,
    aws_lb_listener.patient_auth
  ]
}
