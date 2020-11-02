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
variable "eks_public_subnets_deployed" {
  type = set(string)
}
variable "ssh_keypair" {}
variable "instance_type" {}
variable "sg_description" {}
variable "jumphost_name_suffix" {}
variable "user_data_script" {}
