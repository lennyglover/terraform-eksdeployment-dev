# defined at stack level
variable "eks_stack_name" {}
variable "aws_region" {}
variable "aws_common_resource_tags" {
  type        = map(string)
}
variable "aws_forbidden_account_ids" {
  type = list
}
variable aws_allowed_account_ids {
  type = list
}

# defined at VPC level
variable "vpc_name_suffix" {}
variable "vpc_cidr" {}
variable "vpc_private_subnets" {
  type = list
}
variable "vpc_public_subnets" {
  type = list
}
variable "vpc_enable_nat_gateway" {
  type = bool
}
variable "vpc_enable_dns_hostnames" {
  type = bool
}
variable "vpc_public_subnet_tags" {
  type        = map(string)
}
variable "vpc_private_subnet_tags" {
  type        = map(string)
}
