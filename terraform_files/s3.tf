resource "aws_s3_bucket" "portal26-demo-s3" {
  bucket = join("-", ["portal26", var.tenant_name])

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
