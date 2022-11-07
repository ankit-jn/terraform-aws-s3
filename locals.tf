locals {

    is_sse_kms = (var.enable_sse 
                        && lookup(var.server_side_encryption, "sse_algorithm", "AES256") == "aws:kms")

    create_kms_key = local.is_sse_kms && var.create_kms_key

    kms_key = local.create_kms_key ? module.encryption_key[0].key_id : lookup(var.server_side_encryption, "kms_key", null)
}