# resource "aws_apigatewayv2_integration" "integration_lb_portal" {
#   api_id           = aws_apigatewayv2_api.api_gateway.id
#   description      = "Api gateway for portal load balancer"
#   integration_type = "HTTP_PROXY"
#   integration_uri  = aws_lb_listener.portal.arn
#   integration_method = "ANY"
#   connection_type    = "VPC_LINK"
#   connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id
#   timeout_milliseconds = 30000
#   credentials_arn  = aws_iam_role.api_gateway_role.arn

#   request_parameters = {
#     "overwrite:path" = "$request.path"
#   }

#   depends_on = [ 
#     aws_apigatewayv2_vpc_link.vpc_link,
#     aws_lb.portal,
#     aws_apigatewayv2_api.api_gateway            
#   ]
# }

# resource "aws_apigatewayv2_route" "create_portal_route" {
#   depends_on         = [aws_apigatewayv2_integration.integration_lb_portal]
#   api_id             = aws_apigatewayv2_api.api_gateway.id
#   route_key          = "POST /v1/user"
#   target             = "integrations/${aws_apigatewayv2_integration.integration_lb_portal.id}"
# }

# resource "aws_apigatewayv2_route" "update_portal_route" {
#   depends_on         = [aws_apigatewayv2_integration.integration_lb_portal]
#   api_id             = aws_apigatewayv2_api.api_gateway.id
#   route_key          = "PUT /v1/user"
#   target             = "integrations/${aws_apigatewayv2_integration.integration_lb_portal.id}"
#   authorization_type = "CUSTOM"
#   authorizer_id      = aws_apigatewayv2_authorizer.jwt_auth.id
# }

# resource "aws_apigatewayv2_route" "get_portal_route" {
#   depends_on         = [aws_apigatewayv2_integration.integration_lb_portal]
#   api_id             = aws_apigatewayv2_api.api_gateway.id
#   route_key          = "GET /v1/user"
#   target             = "integrations/${aws_apigatewayv2_integration.integration_lb_portal.id}"
#   authorization_type = "CUSTOM"
#   authorizer_id      = aws_apigatewayv2_authorizer.jwt_auth.id
# }

# resource "aws_apigatewayv2_stage" "portal_stage" {
#   api_id = aws_apigatewayv2_api.api_gateway.id
#   name   = "portal"
#   auto_deploy = true

#   access_log_settings {
#     destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
#     format = jsonencode({
#       requestId            = "$context.requestId"
#       ip                   = "$context.identity.sourceIp"
#       caller               = "$context.identity.caller"
#       user                 = "$context.identity.user"
#       requestTime          = "$context.requestTime"
#       requestTimeEpoch     = "$context.requestTimeEpoch"
#       httpMethod           = "$context.httpMethod"
#       resourcePath         = "$context.resourcePath"
#       status               = "$context.status"
#       protocol             = "$context.protocol"
#       responseLength       = "$context.responseLength"
#       integrationError     = "$context.integrationErrorMessage"
#       integrationStatus    = "$context.integrationStatus"
#       integrationLatency   = "$context.integrationLatency"
#       responseLatency      = "$context.responseLatency"
#       userAgent            = "$context.identity.userAgent"
#       stage                = "$context.stage"
#       domainName           = "$context.domainName"
#       apiId                = "$context.apiId"
#     })
#   }
# }

# output "portal_endpoint" {
#   value = aws_apigatewayv2_stage.portal_stage.invoke_url
# }
