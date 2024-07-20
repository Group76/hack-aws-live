resource "aws_apigatewayv2_integration" "integration_lb_patient_auth" {
  api_id           = aws_apigatewayv2_api.api_gateway.id
  description      = "Api gateway for patient_auth load balancer"
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.patient_auth.arn
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id
  timeout_milliseconds = 30000
  credentials_arn  = aws_iam_role.api_gateway_role.arn

  request_parameters = {
    "overwrite:path" = "$request.path"
  }

  depends_on = [ 
    aws_apigatewayv2_vpc_link.vpc_link,
    aws_lb.patient_auth,
    aws_apigatewayv2_api.api_gateway            
  ]
}

resource "aws_apigatewayv2_route" "create_patient_auth_route" {
  depends_on         = [aws_apigatewayv2_integration.integration_lb_patient_auth]
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "POST /v1/user"
  target             = "integrations/${aws_apigatewayv2_integration.integration_lb_patient_auth.id}"
}

resource "aws_apigatewayv2_route" "update_patient_auth_route" {
  depends_on         = [aws_apigatewayv2_integration.integration_lb_patient_auth]
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "PUT /v1/user"
  target             = "integrations/${aws_apigatewayv2_integration.integration_lb_patient_auth.id}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.patient_jwt_auth.id
}

resource "aws_apigatewayv2_route" "get_patient_auth_route" {
  depends_on         = [aws_apigatewayv2_integration.integration_lb_patient_auth]
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "GET /v1/user"
  target             = "integrations/${aws_apigatewayv2_integration.integration_lb_patient_auth.id}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.patient_jwt_auth.id
}

resource "aws_apigatewayv2_route" "get_token_patient" {
  depends_on         = [aws_apigatewayv2_integration.integration_lb_patient_auth]
  api_id             = aws_apigatewayv2_api.api_gateway.id
  route_key          = "POST /v1/auth"
  target             = "integrations/${aws_apigatewayv2_integration.integration_lb_patient_auth.id}"
}

resource "aws_apigatewayv2_stage" "patient_auth_stage" {
  api_id = aws_apigatewayv2_api.api_gateway.id
  name   = "patient"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
    format = jsonencode({
      requestId            = "$context.requestId"
      ip                   = "$context.identity.sourceIp"
      caller               = "$context.identity.caller"
      user                 = "$context.identity.user"
      requestTime          = "$context.requestTime"
      requestTimeEpoch     = "$context.requestTimeEpoch"
      httpMethod           = "$context.httpMethod"
      resourcePath         = "$context.resourcePath"
      status               = "$context.status"
      protocol             = "$context.protocol"
      responseLength       = "$context.responseLength"
      integrationError     = "$context.integrationErrorMessage"
      integrationStatus    = "$context.integrationStatus"
      integrationLatency   = "$context.integrationLatency"
      responseLatency      = "$context.responseLatency"
      userAgent            = "$context.identity.userAgent"
      stage                = "$context.stage"
      domainName           = "$context.domainName"
      apiId                = "$context.apiId"
    })
  }
}

output "patient_auth_endpoint" {
  value = aws_apigatewayv2_stage.patient_auth_stage.invoke_url
}
