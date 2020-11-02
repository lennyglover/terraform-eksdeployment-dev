##################################################################
# Build an AWS Linux host for use as a bastion to provide access 
# to all areas of the EKS cluster infrastructure
##################################################################
resource "aws_instance" "jumphost" {

  # AMI is AWS Linux 2 latest release at time of build
  ami = data.aws_ami.latest_aws_2_ami.id

  #need large instance to build docker images
  instance_type = var.instance_type
  
  key_name = var.ssh_keypair
  # security group created in jumphost_sg.tf
  security_groups = [ aws_security_group.ssh_access_to_db_jump_host.id ]
  
  # put in the first available public subnet
  subnet_id = tolist(var.eks_public_subnets_deployed)[0]
  
  # install software for SNAP EKS application install
  user_data = file(var.user_data_script)
  
  # common AWS tags
  tags = merge(
    var.aws_common_resource_tags,
    { 
      Name = "${var.eks_stack_name}${var.jumphost_name_suffix}"
    },
  )
}

# public IP will be an elastic IP
resource "aws_eip" "public_ip" {
  instance = aws_instance.jumphost.id
  vpc      = true
  
  # common AWS tags
  tags = merge(
    var.aws_common_resource_tags,
    { 
      Name = "${var.eks_stack_name}${var.jumphost_name_suffix}"
    },
  )
}   
