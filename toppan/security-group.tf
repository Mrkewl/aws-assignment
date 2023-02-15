resource "aws_security_group" "fleet_private_sec_grp" {
  vpc_id = aws_vpc.jazz_toppan_vpc.id
  name   = "fleet-sec-grp"
  # ingress {
  #   from_port       = 22
  #   to_port         = 22
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.jazz_elastic_lb_sec_grp.id]
  #   # cidr_blocks = ["0.0.0.0/0"]
  #   # cidr_blocks = [var.my_public_ip]
  # }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.jazz_elastic_lb_sec_grp.id]
    # cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = [var.my_public_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "Jazz-fleet-Security-Group"
  }

}

resource "aws_security_group" "jazz_elastic_lb_sec_grp" {
  vpc_id = aws_vpc.jazz_toppan_vpc.id
  name   = "jazz-alb-sec-grp"
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # security_groups = [aws_security_group.jazz_bastion_sec_grp.id]
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = [var.my_public_ip]
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Listen on port 80"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "Jazz-Security-Group"
  }

}

