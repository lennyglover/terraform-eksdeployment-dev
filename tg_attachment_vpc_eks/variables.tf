# defined at stack level
variable "eks_stack_name" {}
variable "aws_region" {}
variable "aws_common_resource_tags" {
  type = map(string)
}
variable "aws_forbidden_account_ids" {
  type = list
}
variable aws_allowed_account_ids {
  type = list
}

# defined at this level
variable "eks_vpc_id" {}
variable "tgw_id" {}
variable "tgw_default_route_table_association" {} 
variable "tgw_default_route_table_propagation" {}
variable "tgw_additional_static_route_1" {}
variable "tgw_additional_static_route_2" {}
variable "eks_public_subnets_deployed" {
  type = set(string)
}

