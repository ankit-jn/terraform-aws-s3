## S3 bucket Versioning
resource aws_s3_bucket_versioning "this" {

    count = var.enable_versioning ? 1 : 0

    bucket = local.bucket_id

    expected_bucket_owner = var.expected_bucket_owner

    mfa = (lookup(var.versioning, "mfa_delete", "Disabled") == "Enabled") ? lookup(var.versioning, "mfa", null) : null
  
    versioning_configuration {
        status = lookup(var.versioning, "status", "Enabled")
        mfa_delete = lookup(var.versioning, "mfa_delete", "Disabled")
    }
}

## S3 Bucket Server Side Encryption
resource aws_s3_bucket_server_side_encryption_configuration "this" {
  
    count = var.enable_sse ?  1 : 0

    bucket = local.bucket_id
    expected_bucket_owner = var.expected_bucket_owner

    rule {
        bucket_key_enabled = lookup(var.server_side_encryption, "bucket_key_enabled", false)
        
        apply_server_side_encryption_by_default {
            sse_algorithm = try(var.server_side_encryption.sse_algorithm, "AES256")
            kms_master_key_id = local.is_sse_kms ? local.kms_key : null
        }
    }
}

## Transfer Acceleration
resource aws_s3_bucket_accelerate_configuration "this" {

    count = var.transfer_acceleration != null ? 1 : 0

    bucket = local.bucket_id

    status = var.transfer_acceleration
}