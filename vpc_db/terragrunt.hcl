# VPC inputs - DB VPC
inputs = {
  # VPC specific
  vpc_name_suffix = "_db-vpc"  
  vpc_cidr = "172.16.0.0/24"
  vpc_private_subnets = ["172.16.0.0/27", "172.16.0.32/27"]
  vpc_public_subnets  = ["172.16.0.96/27", "172.16.0.128/27"]
  vpc_enable_nat_gateway = false
  vpc_enable_dns_hostnames = true
  vpc_public_subnet_tags = {}
  vpc_private_subnet_tags = {}
}

include {
  path = find_in_parent_folders()
}