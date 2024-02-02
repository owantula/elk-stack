resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Name = "main"
  }
}


resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "main-public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.1.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name = "main-private-subnet"
  }
}

resource "aws_internet_gateway" "intenet_gateway" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-internet-gateway"
  }
}

resource "aws_eip" "nat_gateway" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.private.id

  tags = {
    Name = "main-nat-gateway-private-subnet"
  }
}
 
