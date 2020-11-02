Top-level terragrunt.hcl
All the stack-level configuration is done in the locals {) section at the top of the file 
(this imposes some a loose naming convention and avoids duplication):

The configuration items are these (values are just for illustration):
1. aws_region = "us-east-1"
AWS region in which ALL resources belonging to the stack will be built

2. eks_stack_name = "dev-stack-xxx"
This name will be prefixed to the Name tag of ALL resources created
e.g. The value shown above would result in a jumphost called dev-stack-xxx_jumphost

3. state_files = "penetwork-dev-stack-xxx-state"
This will be the name of the S3 bucket & the DynamoDB table for locking
(the code makes the excellent assumption that we want them to have the same name)
See Pre-Requisites section below 

4. aws_common_resource_tags = {"Owner" : "pe-network", "Project" : "SNAP", "Environment" : "Dev", "Pipeline" : "tbd", "CreatedBy" : "Terraform", "Version" : "1.0"}
These AWS resource tags are applied to ALL resources created as part of the EKS stack
The list is unpacked into separate tags so that the example given above would result in 6 distinct tag items

5. aws_forbidden_account_ids = []
Blacklist of AWS account IDs to which this configuration should NOT be applied. 
An empty list (as shown above) will mean that no AWS accounts are explicitly forbidden
See https://registry.terraform.io/providers/hashicorp/aws/latest/docs
for further details

6. aws_allowed_account_ids = []
Whitelist of AWS account IDs to which this configuration is allowed to be applied.
An empty list (as shown above) will mean that ALL AWS accounts are whitelisted
See https://registry.terraform.io/providers/hashicorp/aws/latest/docs
for further details

PRE_REQUISITES
The following will need to be created in the AWS environment to be deployed to
and in the region specified as aws_region in terragrunt.hcl:
1. S3 bucket and Dynamo DB table for remote state backend
The name is defined in the top-level terragrunt.hcl 
Terragrunt will propogate this value to all the lower level 
backend.tf files without manual intervention
NOTE - The necessary S3 permissions are documented here:
https://www.terraform.io/docs/backends/types/s3.html
The DynamoDB table is documented here (Primary Key needs to be LockID):
https://terragrunt.gruntwork.io/docs/features/keep-your-remote-state-configuration-dry/#create-remote-state-and-locking-resources-automatically

2. In AWS SSM Parameter Store - credentials for RDS instance(s)
These will be consumed by the RDS MySQL module
Create the parameters in Systems Manager, Parameter Store as:
Tier: Standard
Type: Secure String
with Name(s):
matching those defined in /rds_mysql/terragrunt.hcl as
username_parameter
password_parameter

3. Transit Gateway 
The module in /tg_attachment_vpc_eks creates an attachment 
from the VPC EKS to a pre-existing Transit Gateway and will fail if the 
TG specified as "tgw_id" in "/tg_attachment_vpc_eks/terragrunt.hcl" 
does not already exist. 

4. Key Pair
To authenticate to the EC2 instance created by /jumphost, a Key Pair
must exist in the region specified and be named in /jumphost/terragrunt.hcl 
as ssh_keypair

_______________________________________________________________________________________________________________________________
The Terraform modules contained in this directory will build a full EKS stack with
a supporting MySQL RDS instance & an AWS Linux jumphost. 

To initiate a build:
1. Ensure the pre-requisites listed above already exist
2. Ensure that all copies of terragrunt.hcl have been configured with the appropriate information
3. Change to the /build_scripts directory and run the bash script /eks_stack_build.sh

A failure in any module will cause the Go test script to return an exit code of 1, 
which will cause the bash script to abort.

See readme.md files in the individual module directories
for further detail (if there is any)
