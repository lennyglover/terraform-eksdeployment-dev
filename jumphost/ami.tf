# select most recent AWS Linux 2 AMI
data "aws_ami" "latest_aws_2_ami" {
  most_recent       = true
  owners            = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}