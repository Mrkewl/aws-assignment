# #* s3 bucket
resource "aws_s3_bucket" "jazz_s3_cicd" {
  bucket        = "jazz-s3-forcicd"
  force_destroy = true

  acl = "private" # or can be "public-read"

  tags = {

    Name = "Toppan"

    Environment = "Dev"

  }
}

resource "aws_s3_bucket_object" "object" {

  bucket = aws_s3_bucket.jazz_s3_cicd.id

  key    = "html"

  acl    = "private"  # or can be "public-read"

  source = "./index.html"


}
