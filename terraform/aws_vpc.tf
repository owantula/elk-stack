locals {
  vpc_cidr_block = "172.16.0.0/16"
  subnets = {
    private = {
      cidr                    = "172.16.0.0/24"
      map_public_ip_on_launch = true
    }
    public = {
      cidr                    = "172.16.1.0/24"
      map_public_ip_on_launch = false
    }
  }

}


resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Name = "main"
  }
}


resource "aws_subnet" "main" {
  for_each                = local.subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags = {
    Name = format("main-%s-subnet", each.key)
  }
}


resource "aws_internet_gateway" "internet_gateway" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-internet-gateway"
  }
}

resource "aws_eip" "nat_gateway" {
  domain = "vpc"
}

resource "aws_nat_gateway" "private" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.main["private"].id

  tags = {
    Name = "main-nat-gateway-private-subnet"
  }
}

resource "aws_route_table" "main" {
  for_each = local.subnets

  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("main-route-table-%s-subnet", each.key)
  }
}

resource "aws_route_table_association" "main" {
  for_each       = local.subnets
  subnet_id      = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.main[each.key].id
}

resource "aws_route_table_association" "public_igw" {
  subnet_id      = aws_subnet.main["public"].id
  route_table_id = aws_route_table.main["public"].id
}


resource "aws_route" "public_subnet_default_route" {
  route_table_id         = aws_route_table.main["public"].id
  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.internet_gateway.id
}

resource "aws_route" "private_subnet_default_route" {
  route_table_id         = aws_route_table.main["private"].id
  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_nat_gateway.private.id
}
