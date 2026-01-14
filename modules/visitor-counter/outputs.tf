output "function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.counter.function_name
}

output "function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.counter.arn
}

output "function_url" {
  description = "Lambda function URL"
  value       = aws_lambda_function_url.counter.function_url
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.counter.name
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
  value       = aws_dynamodb_table.counter.arn
}
