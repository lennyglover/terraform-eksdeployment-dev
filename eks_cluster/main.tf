##################################################################
# EKS Cluster
# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
# https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html
##################################################################
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "13.0.0"
  cluster_name    = var.eks_stack_name
  cluster_version = var.eks_cluster_version
  subnets         = var.eks_private_subnets_deployed
  vpc_id          = var.eks_vpc_id
  
##################################################################
  node_groups = {
    worker-nodes001 = {
      desired_capacity = var.nodes_desired_capacity
      max_capacity     = var.nodes_max_capacity
      min_capacity     = var.nodes_min_capacity       
      instance_type = var.nodes_instance_class
      
      # k8s_labels applied to node group, Kubernetes labels
      k8s_labels = {
        # any additional k8s labels go here
      }  
    }
  }  
##################################################################
   
  # common AWS tags
  tags = merge(
    var.aws_common_resource_tags,
    { 
      # any additional AWS labels go here
    }
  )
}


