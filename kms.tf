## Provision KMS Key for Code Build output artifact's encryption
module "encryption_key" {
    source = "git::https://github.com/arjstack/terraform-aws-kms.git?ref=v1.0.0"

    count = var.create_kms_key ? 1 : 0

    account_id = data.aws_caller_identity.current.account_id

    description = format("KMS Key for S3 bucket [%s] encryption", var.name)

    key_spec    = "SYMMETRIC_DEFAULT"
    key_usage   = "ENCRYPT_DECRYPT"

    aliases =  [format("%s-key", var.name)]

    key_administrators = [data.aws_caller_identity.current.arn]
    key_grants_users = [data.aws_caller_identity.current.arn]
    key_symmetric_encryption_users = [data.aws_caller_identity.current.arn]

    tags = var.default_tags
}