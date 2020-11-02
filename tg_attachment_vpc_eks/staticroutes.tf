# additional static routes...
data "aws_route_tables" "eks_vpc_tables" { 
  vpc_id = var.eks_vpc_id
}

# BIG BODGE WARNING!!!
# couldn't figure out how to do this - solution to come....
resource "aws_route" "tgw_static_routes_1" {
  count                  = length(data.aws_route_tables.eks_vpc_tables.ids)
  route_table_id         = tolist(data.aws_route_tables.eks_vpc_tables.ids)[count.index]
  destination_cidr_block = var.tgw_additional_static_route_1
  transit_gateway_id     = var.tgw_id
} 
resource "aws_route" "tgw_static_routes_2" {
  count                  = length(data.aws_route_tables.eks_vpc_tables.ids)
  route_table_id         = tolist(data.aws_route_tables.eks_vpc_tables.ids)[count.index]
  destination_cidr_block = var.tgw_additional_static_route_2
  transit_gateway_id     = var.tgw_id
} 

