

resource "aws_iam_policy" "ec2_role_policy" {
  name        = "s3-bucket-access-policy"
  description = "provides permission to access s3"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*",
          "s3-object-lambda:*"
        ],
        "Resource" : "*"
      }
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "RoleForEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "demo-attach" {
  name       = "s3-permission-attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_role_policy.arn
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-iam"
  role = aws_iam_role.ec2_role.name
}