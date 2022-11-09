
data aws_caller_identity "this" {}

## The Canonical User ID
data aws_canonical_user_id "this" {}

data aws_s3_bucket "this" {
    count = var.create ? 0 : 1
  
    bucket = var.name
}
