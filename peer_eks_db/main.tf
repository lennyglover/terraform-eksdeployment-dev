##################################################################
# Create a VPC Peering connection
##################################################################
resource "aws_vpc_peering_connection" "eks_db_peer" {
  vpc_id        = var.eks_vpc_id
  peer_vpc_id   = var.db_vpc_id
  auto_accept   = true

  # common AWS tags
  tags = merge(
    var.aws_common_resource_tags,
    { 
      Name = "${var.eks_vpc_name}-${var.db_vpc_name}_peer-connection"
    },
  )
}  

# Update the route tables in each VPC
# EKS CIDRs to DB VPC and vice versa
data "aws_route_tables" "db_vpc_tables" { 
  vpc_id = var.db_vpc_id
}
data "aws_route_tables" "eks_vpc_tables" { 
  vpc_id = var.eks_vpc_id
}
resource "aws_route" "db_vpc_routes" {
  count                     = length(data.aws_route_tables.db_vpc_tables.ids)
  route_table_id            = tolist(data.aws_route_tables.db_vpc_tables.ids)[count.index]
  destination_cidr_block    = var.eks_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.eks_db_peer.id
} 
resource "aws_route" "eks_vpc_routes" {
  count                     = length(data.aws_route_tables.eks_vpc_tables.ids)
  route_table_id            = tolist(data.aws_route_tables.eks_vpc_tables.ids)[count.index]
  destination_cidr_block    = var.db_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.eks_db_peer.id
} 
