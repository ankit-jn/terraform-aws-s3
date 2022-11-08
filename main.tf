## S3 bucket
resource aws_s3_bucket "this" {
    bucket = var.name
    
    force_destroy = var.force_destroy
    object_lock_enabled = var.object_lock_enabled

    tags = merge({"Name" = format("%s", var.name)}, var.default_tags)
}

## The canned ACL
resource aws_s3_bucket_acl "this" {

    count = ((try(length(var.grants), 0) > 0) 
                    || (var.acl != null && var.acl != "")) ? 1 : 0

    bucket = aws_s3_bucket.this.id
    expected_bucket_owner = var.expected_bucket_owner
    
    acl    = try(length(var.grants), 0) > 0 ? null : try(var.acl, "private")

    dynamic "access_control_policy" {
        for_each = try(length(var.grants), 0) > 0 ? [1] : []
        content {
            dynamic "grant" {
                for_each = var.grants
                content {
                    permission = grant.value.permission
                    grantee {
                        email_address   = try(grant.value.email, null)
                        id              = try(grant.value.id, null)
                        type            = grant.value.type
                        uri             = try(grant.value.uri, null)
                    }
                }
            }
            owner {
                id = try(var.owner.id, data.aws_canonical_user_id.this.id)
                display_name = try(var.owner.name, null)
            }
        }
    }
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
        bucket_key_enabled = lookup(var.server_side_encryption, "bucket_key_enabled", false)
        
        apply_server_side_encryption_by_default {
            sse_algorithm = try(var.server_side_encryption.sse_algorithm, "AES256")
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

## S3 bucket CORS Configurations
resource aws_s3_bucket_cors_configuration "this" {

    count = length(var.cors_rules) > 0 ? 1 : 0

    bucket = aws_s3_bucket.this.id
    expected_bucket_owner = var.expected_bucket_owner

    dynamic "cors_rule" {
        for_each = var.cors_rules
        content {
            id              = try(cors_rule.value.id, null)

            allowed_methods = cors_rule.value.allowed_methods
            allowed_origins = cors_rule.value.allowed_origins
            allowed_headers = try(cors_rule.value.allowed_headers, null)
            expose_headers  = try(cors_rule.value.expose_headers, null)
            max_age_seconds = try(cors_rule.value.max_age_seconds, null)
        }
    }
}

## Transfer Acceleration
resource aws_s3_bucket_accelerate_configuration "this" {

    count = var.transfer_acceleration != null ? 1 : 0

    bucket = aws_s3_bucket.this.id

    status = var.transfer_acceleration
}