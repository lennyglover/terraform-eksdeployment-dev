# data from the VPC
dependency "vpc_eks" {
  config_path = "../vpc_eks"
}

# defined at this level
inputs = {
  eks_vpc_id                   = dependency.vpc_eks.outputs.vpc_id
  eks_private_subnets_deployed = dependency.vpc_eks.outputs.vpc_private_subnets_deployed

  eks_cluster_version = "1.17"
    
  # Indicates whether or not the Amazon EKS private API server endpoint is enabled
  cluster_endpoint_private_access = true
  
  # Indicates whether or not the Amazon EKS public API server endpoint is enabled
  cluster_endpoint_public_access = true
  
  # nodes_desired_capacity must be => nodes_min_capacity AND <= nodes_max_capacity
  nodes_desired_capacity = 3
  nodes_max_capacity     = 5
  nodes_min_capacity     = 1
  
  # an be sized according to need, e.g. smaller instance for dev
  nodes_instance_class = "t2.micro" 
}

# these components must have already been created...
dependencies {
  paths = ["../vpc_eks"]
}

include {
  path = find_in_parent_folders()
}

