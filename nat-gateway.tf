# Elastic IP for NAT gateway 
resource "aws_eip" "eip1" { 
  domain= #

  tags = {
    Name = #
  } 
} 

# NAT gateway for private subnet internet access 
resource "aws_nat_gateway" "nat_gateway_az1" { 
  allocation_id = #
  subnet_id     =

  tags = {
    Name = #
}

# Ensure the NAT Gateway is created after the Internet Gateway 
depends_on = #
} 

# Private route table routes traffic through NAT gateway 
resource "aws_route_table" "private_route_table" {
  vpc_id = #

  route {
    cidr_block
    nat_gateway_id
  }

  tags = {
    Name =
  }
} 

# Associate private subnets with private route table
resource "aws_route_table_association" "private_app_subnet_azl_rt_association" { 
subnet_id      = #
route_table_id = #
} 
resource "aws_route_table_association" "private_data_subnet_azl_rt_association" { 
subnet_id      = #
route_table_id = #
} 
resource "aws_route_table_association" "private_app_subnet_az2_rt_association" { 
subnet_id      = #
route_table_id = #
} 
resource "aws_route_table_association" "private_data_subnet_az2_rt_association" { 
subnet_id      = #
route_table_id = #
} 
