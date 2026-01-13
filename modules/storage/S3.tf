resource "random_string" "bucket_name_random" {
  length  = 10
  upper   = false
  special = false
}

#Bucket Creation
resource "aws_s3_bucket" "web_bucket" {
  bucket = "web-bucket-${random_string.bucket_name_random.result}"

  tags = var.common_tags
}
