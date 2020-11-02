provider "aws" {
  region  = var.aws_region
  
  forbidden_account_ids = var.aws_forbidden_account_ids
  allowed_account_ids = var.aws_allowed_account_ids
}

  
  
  