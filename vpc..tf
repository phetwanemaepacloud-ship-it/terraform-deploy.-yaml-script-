resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "____" app name 
  }
}

# Internet gateway for public subnet internet access 
resource "aws_internet_gateway" "internet_gateway" { 
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "dev-igw"
  }
}

===========================================================

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = #
  instance tenancy     = #
  enable_dns_hostnames = #

  tags = {
    Name = #
  }
} 

# Internet gateway for public subnet internet access
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = #

  tags = {
    Name = #
  }
}

# Get available AZs in the region
data "aws_availability_zones" "available_zones" {}

#Public subnets (internet-facing resources) 
resource "aws_subnet" "public_subnet_az1" { 
  vpc_id                  =
  cidr_block              =
  availability zone       =
  map_public_ip_on_launch = #

  tags = { 
    Name = #
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = #
  cidr_block              = #
  availability_zone       = #
  map_public_ip_on_launch = #

  tags = {
    Name = #
  }
} 

# Public route table routes traffic to the internet gateway 
resource "aws_route_table" "public route_table" {
  vpc_id = #
  
  route {
   cidr_block = # 
   gateway_id = #
  }

  tags = {
    Name = #
  }
} 


# Associate public subnets with public route table
resource "aws_route_table_association" "public_subnet_azl_rt_association" { 
  subnet_id      = #
  route_table_id = #
} 

resource "aws_route_table_association" "public_subnet_az2_rt_association" { 
  subnet_id      = #
  route_table_id = #
} 

# Private app subnets (application tier - ECS, EKS, EC2) 
resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id                  = #
  cidr_block              = #
  availability_zone       = #
  map_public_ip_on_launch = #

  tags = {
    Name = #
  }
} 

resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id                  = #
  cidr_block              = #
  availability_zone       = #
  map_public_ip_on_launch = #

  tags = { 
    Name = #
  }
} 


# Private data subnets (database tier RDS, ElastiCache) 
resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id                  = #
  cidr_block              = #
  availability_zone       = # 
  map_public_ip_on_launch = #

  tags = {
  Name = #
  }
} 

resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id                  = #
  cidr_block              = #
  availability_zone       = #
  map_public_ip_on_launch = #

  tags = {
    Name = #
  }
} 

