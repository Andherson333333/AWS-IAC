# Creacion de subnet privadas
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = var.vpc_id
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.private_azs, count.index)

  tags = merge(var.private_subnet_tags, {
    Name = "Private Subnet ${count.index + 1}"
  })
}


# Creación de tablas de rutas para subredes privadas
resource "aws_route_table" "private_rt" {
  count  = length(var.private_subnet_cidr_blocks)
  vpc_id = var.vpc_id

  tags = {
    Name = "Private Route Table ${count.index + 1}"
  }
}


# Asociacion automatica por nombres
resource "aws_route_table_association" "private_subnet_asso" {
  for_each = { for idx, subnet in aws_subnet.private_subnets : idx => subnet if contains(keys(subnet.tags), "Name") }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt[each.key].id
#  depends_on     = [aws_route_table.private_rt[each.key]]
}

