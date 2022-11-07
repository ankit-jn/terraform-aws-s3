## S3 bucket
resource aws_s3_bucket "this" {
    bucket = var.name
    
    force_destroy = var.force_destroy
    object_lock_enabled = var.object_lock_enabled

    tags = merge({"Name" = format("%s", var.name)}, var.default_tags)
}

## The canned ACL
resource aws_s3_bucket_acl "this" {
    bucket = aws_s3_bucket.this.id
    acl    = var.acl

    expected_bucket_owner = var.expected_bucket_owner
}

## S3 bucket Versioning
resource aws_s3_bucket_versioning "this" {

    count = var.enable_versioning ? 1 : 0

    bucket = aws_s3_bucket.this.id

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

    bucket = aws_s3_bucket.this.id

    expected_bucket_owner = var.expected_bucket_owner

    rule {
        bucket_key_enabled = lookup(var.server_side_encryption, "bucket_key_enabled", null)
        
        apply_server_side_encryption_by_default {
            sse_algorithm = lookup(var.server_side_encryption, "sse_algorithm", "AES256")
            kms_master_key_id = local.is_sse_kms ? local.kms_key : null
        }
    }
}

## Manages S3 bucket-level Public Access
resource aws_s3_bucket_public_access_block "this" {
    bucket = aws_s3_bucket.this.id

    block_public_acls       = try(var.bucket_public_access.block_public_acls, true)
    block_public_policy     = try(var.bucket_public_access.block_public_policy, true)
    ignore_public_acls      = try(var.bucket_public_access.ignore_public_acls, true)
    restrict_public_buckets = try(var.bucket_public_access.restrict_public_buckets, true)
}