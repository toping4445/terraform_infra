################################################################################
# VPC
################################################################################
resource "aws_vpc" "mlops" {
  cidr_block = local.config.networks.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf-mlops-vpc"
  }
}

################################################################################
# Subnet - Private
################################################################################
resource "aws_subnet" "private" {
  count = length(local.config.networks.subnets.private.cidr)

  vpc_id            = aws_vpc.mlops.id
  cidr_block        = local.config.networks.subnets.private.cidr[count.index]
  availability_zone = local.config.availability_zones[count.index]

  tags = {
    Name = "tf-mlops-private-subnet-${local.config.availability_zones[count.index]}"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

output "private_subnets" {
  description = "The IDs of the private subnets as list"
  value       = ["${aws_subnet.private.*.id}"]
}


################################################################################
# Route Table
################################################################################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.mlops.id

  tags = {
    Name = "tf-mlops-private-rt"
  }
}


################################################################################
# Association Subnet
################################################################################

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private.*.id)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

################################################################################
# Route all ip -> DX 
################################################################################

#resource "aws_route" "private_to_dx" {
#  route_table_id         = aws_route_table.private.id
#  destination_cidr_block = "0.0.0.0/0"
#  transit_gateway_id         = aws_nat_gateway.service.id
#}


################################################################################
# Route all ip -> VPC Endpoint
################################################################################

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.mlops.id
  service_name = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Interface"
}

resource "aws_vpc_endpoint" "stepfunction" {
  vpc_id       = aws_vpc.mlops.id
  service_name = "com.amazonaws.ap-northeast-2.states"
  vpc_endpoint_type = "Interface"
}

resource "aws_vpc_endpoint" "sagemaker_api" {
  vpc_id       = aws_vpc.mlops.id
  service_name = "com.amazonaws.ap-northeast-2.sagemaker.api"
  vpc_endpoint_type = "Interface"
}
