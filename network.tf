################################################################################
# VPC
################################################################################
resource "aws_vpc" "mlops" {
  cidr_block = local.config.networks.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MLOps-VPC"
  }
}

################################################################################
# Subnet - Private
################################################################################
resource "aws_subnet" "private" {
  count = length(local.config.networks.subnets.private.cidr)

  vpc_id            = aws_vpc.service.id
  cidr_block        = local.config.networks.subnets.private.cidr[count.index]
  availability_zone = local.config.availability_zones[count.index]

  tags = {
    Name = "Service-Private-Subnet-${local.config.availability_zones[count.index]}"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


################################################################################
# Route Table
################################################################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.service.id

  tags = {
    Name = "Service-Public-RT"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.service.id

  tags = {
    Name = "Service-Private-RT"
  }
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.service.id

  tags = {
    Name = "Service-Database-RT"
  }
}

################################################################################
# Association Subnet
################################################################################
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public.*.id)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private.*.id)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(aws_subnet.database.*.id)

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}

################################################################################
# Route
################################################################################
resource "aws_route" "public_all_outbound" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.service.id
}

resource "aws_route" "private_all_outbound" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.service.id
}
