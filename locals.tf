locals {

    bucket_id = var.create ? aws_s3_bucket.this[0].id : data.aws_s3_bucket.this[0].id
    bucket_arn = var.create ? aws_s3_bucket.this[0].arn : data.aws_s3_bucket.this[0].arn
    bucket_region = var.create ? aws_s3_bucket.this[0].region : data.aws_s3_bucket.this[0].region
    
    is_sse_kms = (var.enable_sse 
                        && try(var.server_side_encryption.sse_algorithm, "AES256") == "aws:kms")

    create_kms_key = local.is_sse_kms && var.create_kms_key

    kms_key = local.create_kms_key ? module.encryption_key[0].key_id : lookup(var.server_side_encryption, "kms_key", null)
}