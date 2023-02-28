
resource "aws_instance" "tf-1" {
  ami           = "ami-0f2eac25772cd4e36"
  subnet_id = aws_subnet.tf-example-public-ap-southeast-1[0].id
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.default.id ]
  tags = {
    Name = "Hello terraform"
  }
}