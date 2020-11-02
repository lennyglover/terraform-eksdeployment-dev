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


# defined at this level
variable "eks_vpc_id" {}
variable "eks_vpc_name" {}
variable "eks_vpc_cidr" {}
variable "db_vpc_id" {}
variable "db_vpc_name" {}
variable "db_vpc_cidr" {}



