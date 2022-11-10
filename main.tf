## S3 bucket
resource aws_s3_bucket "this" {
    count = var.create ? 1 : 0

    bucket = var.name
    
    force_destroy = var.force_destroy
    object_lock_enabled = var.object_lock_enabled

    tags = merge({"Name" = format("%s", var.name)}, var.default_tags)
}