# Creacion subnet
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidr_blocks)
  vpc_id            = var.vpc_id
  cidr_block        = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone = element(var.public_azs, count.index)
  
  tags = merge(var.public_subnet_tags, {
    Name = "Public Subnet ${count.index + 1}"
  })
}

# Creación de IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id
  
  tags = {
    Name = "Nuevo-IGW"
  }
}

# Creación de tabla pública
resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  
  tags = {
    Name = "2nd Route Table"
  }
}

# Creación de la asociación de tabla de rutas con subredes públicas
resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(aws_subnet.public_subnets[*].id)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
