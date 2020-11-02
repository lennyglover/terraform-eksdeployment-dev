output "tg_attachment_id" {
  description = "Transit Gateway attachment ID"
  value = aws_ec2_transit_gateway_vpc_attachment.vpc_eks_transit_gateway.id
}
