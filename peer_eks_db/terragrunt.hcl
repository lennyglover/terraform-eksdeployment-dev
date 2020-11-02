# data from the VPCs to be peered
dependency "vpc_eks" {
  config_path = "../vpc_eks"
}
dependency "vpc_db" {
  config_path = "../vpc_db"
}

# defined at this level
inputs = {
  eks_vpc_id   = dependency.vpc_eks.outputs.vpc_id
  eks_vpc_name = dependency.vpc_eks.outputs.vpc_name
  eks_vpc_cidr = dependency.vpc_eks.outputs.vpc_cidr_block
  db_vpc_id    = dependency.vpc_db.outputs.vpc_id
  db_vpc_name  = dependency.vpc_db.outputs.vpc_name
  db_vpc_cidr  = dependency.vpc_db.outputs.vpc_cidr_block
}

# these components must have already been created...
dependencies {
  paths = ["../vpc_eks", "../vpc_db"]
}

include {
  path = find_in_parent_folders()
}

