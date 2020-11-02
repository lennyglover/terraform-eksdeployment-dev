# locals
locals {
  aws_region = "us-east-2"
  eks_stack_name = "dev-stack-xxx"
  state_files = "penetwork-dev-stack-xxx-state"
  aws_common_resource_tags = {"Owner" : "pe-network", "Project" : "SNAP", "Environment" : "Dev", "Pipeline" : "tbd", "CreatedBy" : "Terraform", "Version" : "1.0"}
  aws_forbidden_account_ids = []
  aws_allowed_account_ids = []
}

# VPC inputs - stack level
inputs = {
  eks_stack_name = local.eks_stack_name
  aws_region = local.aws_region
  aws_common_resource_tags = local.aws_common_resource_tags

  # Blacklist - e.g. Prod account
  aws_forbidden_account_ids = local.aws_forbidden_account_ids

  # Whitelist - e.g. dev account
  aws_allowed_account_ids = local.aws_allowed_account_ids
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.state_files
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = local.state_files
  }
}