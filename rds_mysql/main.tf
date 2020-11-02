##################################################################
# Builds an RDS MySQL instance
##################################################################
module "rds" {
  source = "terraform-aws-modules/rds/aws"
  version = "2.20.0"

  # RDS instance name
  identifier = "${var.eks_stack_name}${var.instance_identifier_suffix}"

  # MySQL DB values
  engine                    = "mysql"
  engine_version            = var.mysql_engine_version
  family                    = var.db_family
  major_engine_version      = var.major_engine_version
  multi_az                  = var.multi_az
  instance_class            = var.db_instance_class  
  allocated_storage         = var.allocated_storage
  storage_encrypted         = var.storage_encrypted
  apply_immediately         = var.apply_immediately
  deletion_protection       = var.deletion_protection
  
  # Backup/maintenance
  maintenance_window        = var.maintenance_window
  backup_window             = var.backup_window  
  backup_retention_period   = var.backup_retention_period
  final_snapshot_identifier = var.final_snapshot_identifier
  copy_tags_to_snapshot     = var.copy_tags_to_snapshot

  # credentials
  username                  = data.aws_ssm_parameter.rds_mysql_username.value
  password                  = data.aws_ssm_parameter.rds_mysql_password.value
  
  # Connectivity
  port                   = var.mysql_port 
  vpc_security_group_ids = [aws_security_group.mysql_db_access.id]
  # all DB VPC subnets
  subnet_ids             = data.aws_subnet_ids.db_vpc.ids
  
  # common AWS tags
  tags = merge(
    var.aws_common_resource_tags,
    { 
      # Add any other AWS tags here...
    },
  )
}
