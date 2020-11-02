#!/bin/bash
#**********************************************************************************************************************
# run Go tests that deploy Terraform code for a single component
# input - full path to test script directory
# output - true or false
function install_aws_component() {
    cd $1/tests/
    go test --timeout 60m
    return $?
}
#**********************************************************************************************************************

# Main execution starts here
# these three env vars determine if it's a deploy or destroy
# (consumed by TerraTest)
export SKIP_deploy=""
export SKIP_validate=""
export SKIP_cleanup="true"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
MODULES_DIR="$( echo $(cd ../ && pwd) )"

# Logging - uncomment the export statements to enable verbose logging
now=$(date +'%y%m%d%H%M%S')
terraform_log_file=$SCRIPT_DIR/$now-build.log
#export TF_LOG=TRACE
#export TF_LOG_PATH=${terraform_log_file}

# Controls the Terraform Infrastructure build
# If any component fails then build is halted and a failure reported back to the pipeline
#EKS (public) VPC
if ! install_aws_component "$MODULES_DIR/vpc_eks"; then return 1; fi

#DB (private) VPC
if ! install_aws_component "$MODULES_DIR/vpc_db"; then return 1; fi

# VPC Peering attachment
if ! install_aws_component "$MODULES_DIR/peer_eks_db"; then return 1; fi

# TG Attachment
if ! install_aws_component "$MODULES_DIR/tg_attachment_vpc_eks"; then return 1; fi

# Jump Box
if ! install_aws_component "$MODULES_DIR/jumphost"; then return 1; fi

exit

# RDS MySQL
if ! install_aws_component "$MODULES_DIR/rds_mysql"; then return 1; fi

# EKS Cluster
if ! install_aws_component "$MODULES_DIR/eks_cluster"; then return 1; fi

echo "success"