# Create vpc
module "vpc" {
  source                       = "git::ssh://git@github.com:phetwanemaepacloud-ship-it/terraform-deply.-yaml-script-.git//vpc"
  region                       = "____" 
  project_name                 = "my-app" 
  environment                  = "dev" 
  project_directory            = "my-app
  vpc_cidr                     = 10.0.0.0/16
  public_subnet_azl_cidr       = 10.0.0.0/24
  public_subnet_az2_cidr       = 10.0.1.0/24
  private_app_subnet_azl_cidr  = 10.0.2.0/24
  private_app_subnet_azz_cidr  = 10.0.3.0/24
  private_data_subnet_azl_cidr = 10.0.4.0/24
  private_data_subnet_az2_cidr = 10.0.5.0/24
}  

"Create Nat Gateway 
module "nat-gateway" {
  source                     =
  environment                =
  public_subnet_azl.Id       =
  internet_gateway           =
  vpc_id                     =
  private_app_subnet_az1.Id  =
  private_app_subnet_az1.Id  =
  private_data_subnet_az1.id =
  private_data_subnet_az2.id =
} 
