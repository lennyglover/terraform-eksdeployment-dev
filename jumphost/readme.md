Runtime is typically around 3-4 minutes

In a clean environment, will add 3 resources:
aws_eip.public_ip  x 1 - EC2, Elastic IPs
aws_instance x 1
aws_security_group.ssh_access_to_db_jump_host x 1 

Notes:
Creates a LINUX EC2 instance as a jumphost with access to 
the RDS instance in VPC DB
* creates an AWS linux instance in the first public subnet in the eks cluster vpc
* creates a security group allowing ssh from anywhere
* attaches an EIP for public access

Installs client software for MySQL/MariaDB:
versions as of v1.1 of Terraform code - 
mysql  Ver 15.1 Distrib 10.5.5-MariaDB, for Linux (x86_64) using readline 5.1
Access MySQL db with the following command:
$ mysql -h <mysql db public dns name or IP> -P 3306 -u <admin username> -p
(will prompt for password)
When connected, run 
show databases;
at the mysql prompt to verify that the DB has been created     

AWS CLI already installed with AMI - aws-cli/1.18.107 Python/2.7.18 Linux/4.14.193-149.317.amzn2.x86_64 botocore/1.17.31

Installs tools for Docker & EKS access 
versions as of v1.1 of Terraform code
installs kubectl - Client Version: v1.17.9-eks-4c6976 
installs aws-iam-authenticator - {"Version":"v0.5.0","Commit":"1cfe2a90f68381eacd7b6dcfa2bf689e76eb8b4b"}
installs enables & starts docker service - version 19.03.6-ce
Note: adds ec2-user to Docker group to enable use without calling sudo first
installs git - git version 2.23.3
    
