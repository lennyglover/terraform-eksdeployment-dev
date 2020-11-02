# data from the VPCs to be peered
dependency "vpc_eks" {
  config_path = "../vpc_eks"
}

# defined at this level
inputs = {
  eks_vpc_id                          = dependency.vpc_eks.outputs.vpc_id
  eks_public_subnets_deployed         = dependency.vpc_eks.outputs.vpc_public_subnets_deployed
  tgw_id                              = "tgw-06a4a86c7149abf79"
  tgw_default_route_table_association = false 
  tgw_default_route_table_propagation = false
  tgw_additional_static_route_1       = "173.252.156.64/28"
  tgw_additional_static_route_2       = "10.0.0.0/8"
}

# these components must have already been created...
dependencies {
  paths = ["../vpc_eks"]
}

include {
  path = find_in_parent_folders()
}

