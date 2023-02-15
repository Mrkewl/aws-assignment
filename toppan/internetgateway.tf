#* Elastic IP

resource "aws_eip" "nat_elastic_ip" {
  vpc = true
  tags = {
    "Name" = var.elastic_ip_name
  }
}





#* INTERNET GATEWAY FOR PUBLIC SUBNET
resource "aws_internet_gateway" "alb_igw" {
  vpc_id = aws_vpc.jazz_toppan_vpc.id
  tags = {
    "NAME" = var.alb_igw_name
  }
}






#* Network Address Translation
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_elastic_ip.id
  subnet_id     = aws_subnet.alb_public_subnet.id
  depends_on = [
    # aws_eip.nat_elastic_ip,
    aws_internet_gateway.alb_igw
  ]
}

