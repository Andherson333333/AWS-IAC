### Creacion VPC ####
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
 
  tags = {
    Name = "Nueva-vpc"
  }
}

#### Creacion subnet ####
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
 
  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}
 
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
 
  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

##### Creacion IGW ####
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
 
  tags = {
    Name = "Nuevo-IGW"
  }
}

##### Creacion tabla public ####
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
 
  tags = {
    Name = "2nd Route Table"
  }
}

##### Creacion tabla private-1 ####
resource "aws_route_table" "private-rt1" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "Private Route Table AZ0"
  }
}

##### Creacion tabla private-2 ####
resource "aws_route_table" "private-rt2" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "Private Route Table AZ1"
  }
}

##### Asociacion de subnet a tablas de rutas por tag ######

resource "aws_route_table_association" "private_subnet_asso" {
  for_each       = { for idx, subnet in aws_subnet.private_subnets : idx => subnet if subnet.tags.Name == "Private Subnet 1" }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private-rt1.id   
  depends_on     = [aws_route_table.private-rt1]    
}

resource "aws_route_table_association" "private_subnet_asso2" {
  for_each       = { for idx, subnet in aws_subnet.private_subnets : idx => subnet if subnet.tags.Name == "Private Subnet 2" }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private-rt2.id  
  depends_on     = [aws_route_table.private-rt2]    
}

resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public-rt.id
}

