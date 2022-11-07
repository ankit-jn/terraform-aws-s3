output "id" {
    description = "The name of the bucket."
    value = aws_s3_bucket.this.id
}

output "arn" {
    description = "The ARN of the bucket."
    value = aws_s3_bucket.this.arn
}

output "kms_key" {
    description = "KMS customer master key (CMK) to be used for encrypting the bucket objects"
    value = var.create_kms_key ? {
                                    "key_id" = module.encryption_key[0].key_id
                                    "arn"    = module.encryption_key[0].key_arn 
                                    "policy" = module.encryption_key[0].key_policy 
                                } : null
}
