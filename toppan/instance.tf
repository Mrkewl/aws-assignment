resource "aws_key_pair" "jazz" {
  key_name   = "jazz"
  public_key = file(var.ssh_public_key)

}

# #?#####################?#####################?#####################?####################
# #* autoscaling grp
# #?#####################?#####################?#####################?####################

resource "aws_launch_configuration" "fleet_a_launchconfig" {
  name_prefix = "Fleet A"

  image_id             = "ami-0753e0e42b20e96e3"
  instance_type        = "t2.micro"
  user_data            = file("./shell.sh")
  key_name             = aws_key_pair.jazz.key_name
  security_groups      = [aws_security_group.fleet_private_sec_grp.id]
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  lifecycle {
    create_before_destroy = true
  }


}


resource "aws_autoscaling_group" "fleet_a_asg" {
  min_size             = 3
  max_size             = 4
  desired_capacity     = 3
  launch_configuration = aws_launch_configuration.fleet_a_launchconfig.name
  vpc_zone_identifier  = [aws_subnet.serverfleet_private_subnet.id]
  depends_on = [
    aws_s3_bucket.jazz_s3_cicd,
    aws_s3_bucket_object.object,
    aws_iam_policy.ec2_role_policy,
    aws_iam_role.ec2_role,
    aws_iam_policy_attachment.demo-attach,
    aws_iam_instance_profile.ec2-profile
  ]

}
# #?#####################?#####################?#####################?####################



# #* test on alb subnet
resource "aws_instance" "bastion" {
  ami                         = "ami-0753e0e42b20e96e3"
  count                       = 1
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.alb_public_subnet.id
  iam_instance_profile        = aws_iam_instance_profile.ec2-profile.name
  vpc_security_group_ids      = [aws_security_group.jazz_elastic_lb_sec_grp.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.jazz.key_name
  user_data                   = file("./shell.sh")
  tags = {
    "Name" = "Jazz-bastion"
  }
  depends_on = [
    aws_s3_bucket.jazz_s3_cicd,
    aws_s3_bucket_object.object,
    aws_iam_policy.ec2_role_policy,
    aws_iam_role.ec2_role,
    aws_iam_policy_attachment.demo-attach,
    aws_iam_instance_profile.ec2-profile
  ]
}

