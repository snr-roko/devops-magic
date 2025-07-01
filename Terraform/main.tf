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

# Creating the NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet1.id
  tags = {
    Name = "NAT Gateway"
  }
}


# Creating the public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.production_vpc.id
  route {
    cidr_block = var.all_ipv4_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public RT"
  }
}

# Creating the private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.production_vpc.id
  route {
    cidr_block = var.all_ipv4_cidr
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "Private RT"
  }
}

# creating 2 public subnets
resource "aws_subnet" "public_subnet1" {
  vpc_id = aws_vpc.production_vpc.id
  cidr_block = var.public_subnet1_cidr
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name= "Public Subnet 1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id = aws_vpc.production_vpc.id
  cidr_block = var.public_subnet2_cidr
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  tags = {
    Name= "Public Subnet 2"
  }
}

# creating private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.production_vpc.id
  cidr_block = var.private_subnet1_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name= "Private Subnet"
  }
}

# creating route table associations
resource "aws_route_table_association" "public-sub1-associaation" {
  subnet_id = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public-sub2-association" {
  subnet_id = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private-sub-associaation" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# Creating Security Groups

# Create Jenkins Security Group
# resource "aws_security_group" "jenkins-sg" {
#   name = "Jenkins Security Group"
#   description = "Allowing SSH and Jenkins Port Traffic to and from the instance"
#   ingress = {

#   }
# }
