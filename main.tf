variable "public_subnet_cidrs" {
  type = list(string)
  description = "public subnet cidr value"
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type = list(string)
  description = "private subnet cidr value"
  default = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "azs" {
  type = list(string)
  description = "availability"
  default = ["ap-southeast-1a", "ap-southeast-1b"]
}

provider "aws" {
  profile    = "terraform"
  region     = "ap-southeast-1"
}

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

resource "aws_security_group" "default" {
  name = "HTTP and SSH"
  vpc_id      = aws_vpc.tf-test-15.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "default"
  }
}

resource "aws_instance" "tf-1" {
  ami           = "ami-0f2eac25772cd4e36"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.default.id ]
  tags = {
    Name = "Hello terraform"
  }
}

