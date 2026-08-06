#Environment
region            = "region" 
project name      = "apl" 
environment       = "dev" 
project_directory = "app-name" 

# VPC 
vpc_cidr                     = "10.0.0.0/16" 
public_subnet_azl_cidr       = "10.0.0.0/24"
public_subnet_az2_cidr       = "10.0.1.0/24"
private_app_subnet_azl_cidr  = "10.0.2.0/24"
private_app_subnet_az2_cidr  = "10.0.3.0/24"
private_data_subnet_az1_cidr = "10.0.4.0/24"
private_data_subnet_az2_cidr = "10.0.5.0/24"
# Secrets Manager 
secret_name = "dev_secrets"

# RDS
multi_az_deployment          = #
database_instance_identifier = #
database_instance_class      = #
database engine              = #
database_engine_version      = #
publicly accessible          = #

# EC2
amazon_linux_ami_id = #
ec2_instance_type   = #
flyway_version      = #
sql_script_s3_uri   = #

# ACM
domain name       = #
alternative names = #

