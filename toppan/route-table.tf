#?#####################?#####################?#####################?####################
#* ROUTE TABLE 
#?#####################?#####################?#####################?####################
#? ROUTE TABLE ALB

resource "aws_route_table" "alb_route_table" {
  vpc_id = aws_vpc.jazz_toppan_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.alb_igw.id
  }
  tags = {
    "Name" = var.alb_route_table_name
  }
}





#? ROUTE TABLE Fleet

resource "aws_route_table" "fleet_route_table" {
  vpc_id = aws_vpc.jazz_toppan_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    "Name" = var.fleet_route_table_name
  }
}





#?#####################?#####################?#####################?####################
#* ROUTE TABLE ASSOCIATION
#?#####################?#####################?#####################?####################



#? ALB ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "alb_route_table_association" {
  subnet_id      = aws_subnet.alb_public_subnet.id
  route_table_id = aws_route_table.alb_route_table.id
}

#? Fleet ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "fleet_route_table_association" {
  subnet_id      = aws_subnet.serverfleet_private_subnet.id
  route_table_id = aws_route_table.fleet_route_table.id
}