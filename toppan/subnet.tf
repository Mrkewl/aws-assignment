
# #* ALB subnet

resource "aws_subnet" "alb_public_subnet" {
  vpc_id                  = aws_vpc.jazz_toppan_vpc.id
  cidr_block              = var.alb_public_subnet
  map_public_ip_on_launch = true
  availability_zone = var.alb_public_subnet_availability_zone
  tags = {
    "Name" = var.alb_public_subnet_name
  }

}





#* serverfleet subnet


resource "aws_subnet" "serverfleet_private_subnet" {
  vpc_id                  = aws_vpc.jazz_toppan_vpc.id
  cidr_block              = var.serverfleet_private_subnet
  map_public_ip_on_launch = false
  availability_zone = var.serverfleet_private_subnet_availability_zone
  tags = {
    "Name" = var.serverfleet_private_subnet_name
  }
}


