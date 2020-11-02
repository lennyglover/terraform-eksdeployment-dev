# Data sources - list all subnets for EKS & DB VPCs
data "aws_subnet_ids" "eks_vpc" {
  vpc_id = var.eks_vpc_id
}
data "aws_subnet" "eks_subnet" {
  for_each = data.aws_subnet_ids.eks_vpc.ids
  id       = each.value
}

data "aws_subnet_ids" "db_vpc" {
  vpc_id = var.db_vpc_id
}
data "aws_subnet" "db_subnet" {
  for_each = data.aws_subnet_ids.db_vpc.ids
  id       = each.value
}
