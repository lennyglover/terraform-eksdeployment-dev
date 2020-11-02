##################################################################
# Create an attachment to a given Transit Gateway 
# & add static routes to (all) EKS VPC route tables
##################################################################
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_eks_transit_gateway" {
  vpc_id             = var.eks_vpc_id
  subnet_ids         = var.eks_public_subnets_deployed
  transit_gateway_id = var.tgw_id

  transit_gateway_default_route_table_association = var.tgw_default_route_table_association
  transit_gateway_default_route_table_propagation = var.tgw_default_route_table_propagation

  # common AWS tags
  tags = merge(
    var.aws_common_resource_tags,
    { 
      Name = "${var.eks_stack_name}_tg-attachment"
    },
  )
}    

