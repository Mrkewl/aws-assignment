#* VPC Configurations

resource "aws_vpc" "jazz_toppan_vpc" {
    cidr_block = var.cidr_block
    tags = {
      "Name" = "${var.main_vpc_name}"
    }
}



