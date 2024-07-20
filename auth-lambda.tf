resource "aws_lambda_function" "patient_function" {
  filename         = "patient_lambda.zip"
  function_name    = "AuthFunction"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("patient_lambda.zip")
  layers = [aws_lambda_layer_version.hack_auth_layer.arn]
}

resource "aws_lambda_function" "doctor_function" {
  filename         = "doctor_lambda.zip"
  function_name    = "AuthFunction"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("doctor_lambda.zip")
  layers = [aws_lambda_layer_version.hack_auth_layer.arn]
}

resource "aws_lambda_layer_version" "hack_auth_layer" {
  filename   = "python.zip"
  layer_name = "hack_auth_layer"

  compatible_runtimes = ["python3.12"]
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  inline_policy {
    name   = "lambda-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "*"
        },
        {
          Effect   = "Allow"
          Action   = [
            "dynamodb:GetItem",
            "dynamodb:Scan",
            "dynamodb:Query"
          ]
          Resource = [
            aws_dynamodb_table.patient_table.arn,
            aws_dynamodb_table.doctor_table.arn
          ]
        },
        {
          Effect   = "Allow"
          Action   = [
            "secretsmanager:GetSecretValue"
          ]
          Resource = "*"
        }
      ]
    })
  }
}