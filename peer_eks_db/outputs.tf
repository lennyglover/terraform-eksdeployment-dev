output "peer_connection_id" {
  description = "Peer connection between EKS & DB VPCs"
  value = aws_vpc_peering_connection.eks_db_peer.id
}
output "peer_connection_status" {
  description = "Peer connection status"
  value = aws_vpc_peering_connection.eks_db_peer.accept_status
}