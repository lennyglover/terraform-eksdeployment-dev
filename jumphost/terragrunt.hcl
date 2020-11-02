# data from the target VPC
dependency "vpc_eks" {
  config_path = "../vpc_eks"
}

# defined at this level
inputs = {
  eks_vpc_id                  = dependency.vpc_eks.outputs.vpc_id
  eks_public_subnets_deployed = dependency.vpc_eks.outputs.vpc_public_subnets_deployed
  ssh_keypair                 = "lennyOhio"
  instance_type               = "t2.large"
  sg_description              = "Allow SSH/ICMP access to DB jump host"
  jumphost_name_suffix        = "_jumphost"
  user_data_script            = "install_utilities.sh"
}

# these components must have already been created...
dependencies {
  paths = ["../vpc_eks"]
}

include {
  path = find_in_parent_folders()
}

