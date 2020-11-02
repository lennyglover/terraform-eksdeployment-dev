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
variable "db_vpc_id" {}
variable "instance_identifier_suffix" {}
variable "sg_description" {}
variable "sg_name_suffix" {}
variable "sg_public_suffix" {}
variable "sg_private_suffix" {}
variable "mysql_engine_version" {}
variable "multi_az" {}
variable "db_family" {}
variable "major_engine_version" {}
variable "mysql_port" {}
variable "username_parameter" {}
variable "password_parameter" {}
variable "db_instance_class" {}
variable "allocated_storage" {}
variable "storage_encrypted" {}
variable "apply_immediately" {}
variable "deletion_protection" {}
variable "maintenance_window" {}
variable "backup_window" {}
variable "backup_retention_period" {}
variable "final_snapshot_identifier" {}
variable "copy_tags_to_snapshot" {}


