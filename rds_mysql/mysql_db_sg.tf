##################################################################
# SECURITY GROUP FOR RDS DB - MYSQL
##################################################################
resource "aws_security_group" "mysql_db_access" {
  name        = "${var.eks_stack_name}${var.sg_name_suffix}"
  description = var.sg_description
  vpc_id      = var.db_vpc_id

  # All eks VPC subnets
  ingress {
    description = "${var.eks_stack_name}${var.sg_private_suffix}"
    from_port   = var.mysql_port
    to_port     = var.mysql_port
    protocol    = "tcp"
    cidr_blocks = [for s in data.aws_subnet.eks_subnet : s.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # common AWS tags
  tags = merge(
    var.aws_common_resource_tags,
    { 
      Name = "${var.eks_stack_name}${var.sg_name_suffix}"
    },
  )
}
