output "db_instance_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.backstage.id
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.backstage.arn
}

output "endpoint" {
  description = "RDS connection endpoint (host:port)"
  value       = aws_db_instance.backstage.endpoint
}

output "address" {
  description = "RDS hostname"
  value       = aws_db_instance.backstage.address
}

output "port" {
  description = "RDS PostgreSQL port"
  value       = aws_db_instance.backstage.port
}

output "db_name" {
  description = "Initial database name"
  value       = aws_db_instance.backstage.db_name
}

output "username" {
  description = "RDS master username"
  value       = aws_db_instance.backstage.username
}

output "instance_class" {
  description = "RDS instance class"
  value       = aws_db_instance.backstage.instance_class
}

output "engine_version" {
  description = "RDS PostgreSQL engine version"
  value       = aws_db_instance.backstage.engine_version_actual
}
