output "api_invoke_url" {
  description = "Invoke URL for the API Gateway endpoint"
  value       = "https://${module.function.invoker_id}.execute-api.${var.region}.amazonaws.com/Dev/lambda_db_function"
}
