# IAM policy for Lambda execution
data "aws_iam_policy_document" "assume_lambda_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

#Lambda Role
resource "aws_iam_role" "lambda_db_role" {
  name               = "lambda_db_role"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_role.json

  tags = var.common_tags
}

data "aws_iam_policy_document" "lambda_dynamodb_policy_doc" {
  statement {
    actions   = ["dynamodb:UpdateItem"]
    resources = [var.dynamodb_table_arn]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name   = "lambda-dynamodb-update-policy"
  policy = data.aws_iam_policy_document.lambda_dynamodb_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_db_role_attachment" {
  role       = aws_iam_role.lambda_db_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

#Lambda function code
data "archive_file" "package_function" {
  type        = "zip"
  source_file = "${path.module}/function.py"
  output_path = "${path.module}/function.zip"
}

# Lambda function
resource "aws_lambda_function" "hit_function" {
  filename         = data.archive_file.package_function.output_path
  function_name    = "lambda_db_function"
  role             = aws_iam_role.lambda_db_role.arn
  handler          = "function.lambda_handler"
  source_code_hash = data.archive_file.package_function.output_base64sha256

  runtime = "python3.13"

  tags = var.common_tags
}

#API Gateway HTTP
resource "aws_apigatewayv2_api" "invoker" {
  name          = "invoker-http-api"
  protocol_type = "HTTP"

  tags = var.common_tags
}

resource "aws_apigatewayv2_stage" "invoker" {
  api_id      = aws_apigatewayv2_api.invoker.id
  name        = "Dev"
  auto_deploy = true
  default_route_settings {
    throttling_burst_limit = 5
    throttling_rate_limit  = 5
  }
}

resource "aws_apigatewayv2_route" "invoker" {
  api_id = aws_apigatewayv2_api.invoker.id

  route_key = "ANY /lambda_db_function"
  target    = "integrations/${aws_apigatewayv2_integration.invoker.id}"
}

resource "aws_apigatewayv2_integration" "invoker" {
  api_id                 = aws_apigatewayv2_api.invoker.id
  integration_uri        = aws_lambda_function.hit_function.invoke_arn
  integration_type       = "AWS_PROXY"
  payload_format_version = "2.0"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hit_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.invoker.execution_arn}/*"
}

