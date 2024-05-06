resource "aws_internet_gateway" "gw_test" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Inet GW test"
  }
}

resource "aws_nat_gateway" "nat_gw_test" {
  allocation_id = aws_eip.nat_gw_test.id
  subnet_id     = aws_subnet.nat_gw_test.id

  tags = {
    Name = "NAT Gateway"
  }
}
