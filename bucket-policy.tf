## Bucket Policy
resource aws_s3_bucket_policy "this" {
    count = (var.attach_bucket_policy 
                || (var.policy_content != null && var.policy_content != "")
                || var.attach_policy_deny_insecure_transport
                || var.attach_policy_require_mfa) ? 1 : 0

    bucket = local.bucket_id

    policy = data.aws_iam_policy_document.compact[0].json
}

## Compact all the policies based on conditions
data aws_iam_policy_document "compact" {

    count = (var.attach_bucket_policy 
                || (var.policy_content != null && var.policy_content != "")
                || var.attach_policy_deny_insecure_transport
                || var.attach_policy_require_mfa) ? 1 : 0

    source_policy_documents = compact([
        var.policy_content,
        var.attach_bucket_policy ? data.template_file.policy_template[0].rendered : "",
        var.attach_policy_deny_insecure_transport ? data.aws_iam_policy_document.deny_insecure_transport[0].json : "",
        var.attach_policy_require_mfa ? data.aws_iam_policy_document.deny_non_mfa[0].json : ""
    ])
}

## Provided Bucket Policy
data template_file "policy_template" {
    count = var.attach_bucket_policy ? 1 : 0
    
    template = file("${path.root}/${var.policy_file}")
}

## Bucket Policy to implement in-transit data encryption across bucket operations
data aws_iam_policy_document "deny_insecure_transport" {
    count = var.attach_policy_deny_insecure_transport ? 1 : 0

    statement {
        sid    = "DenyInsecureTransport"
        effect = "Deny"

        actions = [
            "s3:*",
        ]

        resources = [
            local.bucket_arn,
            "${local.bucket_arn}/*",
        ]

        principals {
            type        = "*"
            identifiers = ["*"]
        }

        condition {
            test      = "Bool"
            variable  = "aws:SecureTransport"
            values    = ["false"]
        }
    }
}

## Bucket Policy to implement deny buclet operations if the request is not authenticated by using MFA
data aws_iam_policy_document "deny_non_mfa" {
    count = var.attach_policy_require_mfa ? 1 : 0

    statement {
        sid    = "DenyIfNotMFA"
        effect = "Deny"

        actions = [
            "s3:*",
        ]

        resources = [
            local.bucket_arn,
            "${local.bucket_arn}/*",
        ]

        principals {
            type        = "*"
            identifiers = ["*"]
        }

        condition {
            test      = "Bool"
            variable  = "aws:aws:MultiFactorAuthAge"
            values    = ["false"]
        }
    }
}