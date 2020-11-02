output "jump_host_public_dns" {
  description = "eip - public dns address of the jump host"
  value       = aws_eip.public_ip.public_dns
}
output "jump_host_public_ip" {
  description = "eip - public ip address of the jump host"
  value       = aws_eip.public_ip.public_ip
}
