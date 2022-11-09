output "id" {
    description = "The name of the bucket."
    value = var.create ? aws_s3_bucket.this[0].id : data.aws_s3_bucket.this[0].arn
}

output "arn" {
    description = "The ARN of the bucket."
    value = var.create ? aws_s3_bucket.this[0].arn : data.aws_s3_bucket.this[0].arn
}

output "kms_key" {
    description = "KMS customer master key (CMK) to be used for encrypting the bucket objects"
    value = local.create_kms_key ? {
                                    "key_id" = module.encryption_key[0].key_id
                                    "arn"    = module.encryption_key[0].key_arn 
                                    "policy" = module.encryption_key[0].key_policy 
                                } : null
}