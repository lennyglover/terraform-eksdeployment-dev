#!/bin/bash
#**********************************************************************************************************************
# run Go tests that deploy Terraform code for a single component
# input - full path to test script directory
# output - true or false
function destroy_aws_component() {
    cd $1/tests/
    go test --timeout 60m
}
#**********************************************************************************************************************

# Main execution starts here
# these three env vars determine if it's a deploy or destroy
# (consumed by TerraTest)
export SKIP_deploy="true"
export SKIP_validate="true"
export SKIP_cleanup=""

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
MODULES_DIR="$( echo $(cd ../ && pwd) )"

# Logging - uncomment the export statements to enable verbos logging
now=$(date +'%y%m%d%H%M%S')
terraform_log_file=$SCRIPT_DIR/$now-build.log
#export TF_LOG=TRACE
#export TF_LOG_PATH=${terraform_log_file}

# reverse order to the build defined in build_scripts/eks_stack_build.sh
# and we don't want to stop for any failures
# (this same script can be used to delete even a partially built stack)
# EKS Cluster
destroy_aws_component "$MODULES_DIR/eks_cluster"

# RDS MySQL
destroy_aws_component "$MODULES_DIR/rds_mysql"

# JUMP BOX
destroy_aws_component "$MODULES_DIR/jumphost"

# TG Attachment
destroy_aws_component "$MODULES_DIR/tg_attachment_vpc_eks"

# VPC Peering attachment
destroy_aws_component "$MODULES_DIR/peer_eks_db/"

#DB (private) VPC
destroy_aws_component "$MODULES_DIR/vpc_db/"

#EKS (public) VPC
destroy_aws_component "$MODULES_DIR/vpc_eks/"

echo "destroyed"