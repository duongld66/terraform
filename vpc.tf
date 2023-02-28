
resource "aws_vpc" "tf-test-15" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "tf-example-public-ap-southeast-1" {
  count = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.tf-test-15.id
  cidr_block        = element(var.public_subnet_cidrs, count.index )
  availability_zone = element(var.azs, count.index )
  tags = {
    Name = "tf-example-public-ap-southeast-${count.index + 1}"
  }
}


resource "aws_subnet" "tf-example-private-ap-southeast-1" {
  count = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.tf-test-15.id
  cidr_block        = element(var.private_subnet_cidrs, count.index )
  availability_zone = element(var.azs, count.index )
  tags = {
    Name = "tf-example-private-ap-southeast-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "tf-example-igw" {
  vpc_id = aws_vpc.tf-test-15.id
  tags = {
    Name = "tf-example"
  }
}

resource "aws_route_table" "tf-example-rt-2" {
  vpc_id = aws_vpc.tf-test-15.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-example-igw.id
  }
  tags = {
    Name = "tf-example-rt-2"
  }
}