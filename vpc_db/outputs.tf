######## VPC for DB Cluster #########
# VPC
output "aws_region" {
  value = var.aws_region
}
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}
output "vpc_name" {
  description = "The Name tag of the VPC"
  value       = module.vpc.name
}
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# Subnets
output "vpc_private_subnets_requested" {
  description = "List of private subnets requested"
  value       = var.vpc_private_subnets
}
output "vpc_public_subnets_requested" {
  description = "List of public subnets requested"
  value       = var.vpc_public_subnets
}
output "vpc_private_subnets_deployed" {
  description = "List of IDs of private subnets deployed"
  value       = module.vpc.private_subnets
}
output "vpc_public_subnets_deployed" {
  description = "List of IDs of public subnets deployed"
  value       = module.vpc.public_subnets
}
