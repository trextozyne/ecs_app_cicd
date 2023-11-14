output "codestar_connection_arn" {
  value = aws_codestarconnections_connection.this.arn
}

output "codestar_connection_status" {
  value = aws_codestarconnections_connection.this.connection_status
}