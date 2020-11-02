##############################################################
# Data source to get DB Credentials from AWS SSM Parameter store
# ##############################################################

data "aws_ssm_parameter" "rds_mysql_username" {
  name = var.username_parameter
  with_decryption = true
}
data "aws_ssm_parameter" "rds_mysql_password" {
  name = var.password_parameter
  with_decryption = true
}
