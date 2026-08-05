
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

