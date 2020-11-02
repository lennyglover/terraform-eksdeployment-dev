# VPC inputs - EKS VPC
inputs = {
  # VPC specific
  vpc_name_suffix = "_eks-vpc"  
  vpc_cidr = "10.188.0.0/22"
  vpc_private_subnets = ["10.188.0.0/24", "10.188.2.0/24", "10.188.3.0/24"]
  vpc_public_subnets  = ["10.188.1.0/26", "10.188.1.64/26", "10.188.1.128/26"]
  vpc_enable_nat_gateway = true
  vpc_enable_dns_hostnames = true
  vpc_public_subnet_tags = {"kubernetes.io/role/elb" : "1"}
  vpc_private_subnet_tags = {"kubernetes.io/role/internal-elb" : "1"}
}

include {
  path = find_in_parent_folders()
}