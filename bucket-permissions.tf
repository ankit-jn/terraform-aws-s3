## The canned ACL
resource aws_s3_bucket_acl "this" {

    count = ((try(length(var.grants), 0) > 0) 
                    || (var.acl != null && var.acl != "")) ? 1 : 0

    bucket = local.bucket_id
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

## Manages S3 bucket-level Public Access
resource aws_s3_bucket_public_access_block "this" {

    count = (try(length(keys(var.bucket_public_access)), 0) > 0) ?  1 : 0
    
    bucket = local.bucket_id

    block_public_acls       = try(var.bucket_public_access.block_public_acls, true)
    block_public_policy     = try(var.bucket_public_access.block_public_policy, true)
    ignore_public_acls      = try(var.bucket_public_access.ignore_public_acls, true)
    restrict_public_buckets = try(var.bucket_public_access.restrict_public_buckets, true)
}

## S3 bucket CORS Configurations
resource aws_s3_bucket_cors_configuration "this" {

    count = length(var.cors_rules) > 0 ? 1 : 0

    bucket = local.bucket_id
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