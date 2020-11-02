# VPC
output "aws_region" {
  value = var.aws_region
}
output "requested_port" {
  value = var.mysql_port
}
output "rds_instance_id" {
  description = "The RDS instance ID"
  value       = module.rds.this_db_instance_id
}
output "rds_instance_address" {
  description = "The address of the RDS instance"
  value       = module.rds.this_db_instance_address
}
output "rds_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.rds.this_db_instance_endpoint
}
output "rds_instance_status" {
  description = "The RDS instance status"
  value       = module.rds.this_db_instance_status
}
