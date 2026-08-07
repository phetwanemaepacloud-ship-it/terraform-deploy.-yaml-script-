#Environment
region            = "region" 
project name      = "app" 
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
multi_az_deployment          = "false" 
database_instance_identifier = "app-db"
database_instance_class      = "db____"
database engine              = "mysql" 
database_engine_version      = "8._._" 
publicly accessible          = "false" 

# EC2
amazon_linux_ami_id = "ami" 
ec2_instance_type   = "____" 
flyway_version      = "____" 
sql_script_s3_uri   = "____" :

# ACM
domain name       = "____.com"
alternative names = "*. ____.com"

# ALB
target_type       = "instance"
health_check_path ="/index.php"

# SNS
operator_email = "____"

# Route 53
record_name = "www"

# ASG
web_files_s3_uri             ="s3:uri"
service_provider_file_s3_uri = "s3://AppServiceProvider.php" 
APPLICATION_CODE_FILE_NAME   = "name" 

