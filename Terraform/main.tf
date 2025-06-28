# Creating the VPC
resource "aws_vpc" "production_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Production VPC"
  }
}

# Creating the Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.production_vpc.id
}

# Creating an Elastic IP to associate with NAT Gateway
resource "aws_eip" "nat_eip" {
  depends_on = [ aws_internet_gateway.igw ]
}

/*# Creating the NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet1.id
  tags = {
    Name = "NAT Gateway"
  }
}
*/
