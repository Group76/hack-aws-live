resource "aws_cloudwatch_log_group" "ecs_patient_auth_api" {
  name = "/ecs/patitent-auth-api"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "ecs_patient_auth_api" {
  name           = "ecs/patitent-auth-api"
  log_group_name = aws_cloudwatch_log_group.ecs_patient_auth_api.name
}

resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name = "/aws/apigateway"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "api_gw_logs" {
  name           = "aws/apigateway"
  log_group_name = aws_cloudwatch_log_group.api_gw_logs.name
}

resource "aws_cloudwatch_log_group" "ecs_doctor_auth_api" {
  name = "/ecs/doctor-auth-api"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "ecs_doctor_auth_api" {
  name           = "ecs/doctor-auth-api"
  log_group_name = aws_cloudwatch_log_group.ecs_doctor_auth_api.name
}

resource "aws_cloudwatch_log_group" "ecs_portal_api" {
  name = "/ecs/portal-api"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "ecs_portal_api" {
  name           = "ecs/portal-api"
  log_group_name = aws_cloudwatch_log_group.ecs_portal_api.name
}