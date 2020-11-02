# data from the VPCs to be peered
dependency "vpc_eks" {
  config_path = "../vpc_eks"
}
dependency "vpc_db" {
  config_path = "../vpc_db"
}

# defined at this level
inputs = {
  eks_vpc_id   = dependency.vpc_eks.outputs.vpc_id
  db_vpc_id    = dependency.vpc_db.outputs.vpc_id
  instance_identifier_suffix = "-snap-databases"
  sg_description = "Allow access to MySQL RDS instance in vpc_db"
  sg_name_suffix = "_mysql_db_access"
  sg_public_suffix = "_vpc-eks-public-subnet"
  sg_private_suffix = "_vpc-eks-private-subnet"
  mysql_engine_version = "8.0.20"
  multi_az = true
  db_family = "mysql8.0"
  major_engine_version = "8.0"
  mysql_port = 3306

  # db credentials in SSM Parameter Store
  username_parameter = "/penet/dev/rds_mysql/username"
  password_parameter = "/penet/dev/rds_mysql/password"
  
  # db_instance_class can be sized according to need, e.g. smaller instance for dev
  db_instance_class = "db.t2.micro"
  #db_instance_class = "db.t2.large"

  # Note - to do - investigate enabling storage autoscaling with max_allocated_storage
  allocated_storage = 5
  storage_encrypted = false
  apply_immediately = true

  # NOTE - setting this to true will prevent programmatic deletion of the entire stack
  deletion_protection = false
  
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window = "03:00-06:00"
  
  # Note - DB will build slightly faster if backup_retention_period is set to zero
  # Can be sized according to need, e.g. smaller retention period for dev
  backup_retention_period = 1

  final_snapshot_identifier = "mistraldbfinal"
  copy_tags_to_snapshot = true
}

# these components must have already been created...
dependencies {
  paths = ["../vpc_eks", "../vpc_db"]
}

include {
  path = find_in_parent_folders()
}

