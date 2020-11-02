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
variable "eks_private_subnets_deployed" {
  type = set(string)
}
variable "eks_cluster_version" {}
variable "cluster_endpoint_private_access" {}
variable "cluster_endpoint_public_access" {}
variable "nodes_desired_capacity" {}
variable "nodes_max_capacity" {}
variable "nodes_min_capacity" {}
variable "nodes_instance_class" {}
