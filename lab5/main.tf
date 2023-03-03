provider "aws" {
    region = var.AWS_REGION
    access_key = var.AWS_ACCESS_KEY
    secret_key = var.AWS_SECRET_KEY

}

# Create a bucket
resource "aws_s3_bucket" "my-bucket" {

  bucket = "s3-terraform-bucket-lab-mm"
  acl    = "private"   # or can be "public-read"
  tags = {
    Name        = "My bucket"
    Environment = "dev"
  }

}

resource "aws_s3_bucket_object" "object99" {
        bucket = aws_s3_bucket.my-bucket.id
        
        for_each = fileset("myfiles/", "*")
        key = each.value
        source = "myfiles/${each.value}"
        etag = filemd5("myfiles/${each.value}")
}
