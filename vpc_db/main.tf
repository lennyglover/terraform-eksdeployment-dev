##################################################################
# Build an AWS VPC
##################################################################
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.62.0"
  
  # name is EKS stack name with a suffix
  # this propogates down to all child objects
  name = "${var.eks_stack_name}${var.vpc_name_suffix}"

  # networking
  cidr            = var.vpc_cidr
  azs             = data.aws_availability_zones.available.names
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets
  enable_nat_gateway = var.vpc_enable_nat_gateway
  enable_dns_hostnames = var.vpc_enable_dns_hostnames  

  # all that follows is tagging
  public_subnet_tags = merge(
    var.vpc_public_subnet_tags,
    { 
      # put any other ad-hoc tags in here... 
    },
  )  
  private_subnet_tags = merge(
    var.vpc_private_subnet_tags,
    { 
      # put any other ad-hoc tags in here... 
    },
  )  
  
  # common AWS resource tags
  tags = merge(
    var.aws_common_resource_tags,
    { 
      # put any other ad-hoc tags in here... 
    },
  )  
}

# also tag the default route - makes the AWS console easier to read
resource "aws_default_route_table" "default_table" {
  default_route_table_id = module.vpc.default_route_table_id

  tags = {
    Name = "${var.eks_stack_name}${var.vpc_name_suffix}-default"
  }
}  