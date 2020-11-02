resource "aws_security_group" "ssh_access_to_db_jump_host" {
  name        = "${var.eks_stack_name}${var.jumphost_name_suffix}_sg"
  description = var.sg_description
  vpc_id      = var.eks_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # will need to be tightened when we have more info
    # as to where access needs to be granted to
    cidr_blocks = ["0.0.0.0/0"]
  }

  # note - unit test for jumphost
  # uses ping to verify deployment - see readme.md
  ingress {
    # also should be tightened up when we have more information
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "icmp"
    from_port = -1
    to_port = -1
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
      Name = "${var.eks_stack_name}${var.jumphost_name_suffix}_sg"
    },
  )
}
