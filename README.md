# ARJ-Stack: AWS Simple Srtorage Servcie (S3) Terraform module

A Terraform module for configuring S3 buckets

## Resources
This module features the following components to be provisioned with different combinations:

- S3 Bucket [[aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)]
- The canned ACL [[aws_s3_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl)]
- S3 bucket Versioning [[aws_s3_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning)]
- S3 Bucket Server Side Encryption [[aws_s3_bucket_server_side_encryption_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration)]
- S3 bucket-level Public Access [[aws_s3_bucket_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)]

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |

## Examples

Refer [Configuration Examples](https://github.com/arjstack/terraform-aws-examples/tree/main/aws-security-groups) for effectively utilizing this module.

## Inputs

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="name"></a> [name](#input\_name) | The name of the bucket | `string` |  | yes | |
| <a name="force_destroy"></a> [force_destroy](#input\_force\_destroy) | Flag to decide if all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error | `bool` | `false` | no | |
| <a name="object_lock_enabled"></a> [object_lock_enabled](#input\_object\_lock\_enabled) | Flag to decide if this bucket has an Object Lock configuration enabled. | `bool` | `null` | no | |
| <a name="acl"></a> [acl](#input\_acl) | The canned ACL to apply to the bucket. | `string` | `private` | no | |
| <a name="expected_bucket_owner"></a> [expected_bucket_owner](#input\_expected\_bucket\_owner) | The account ID of the expected bucket owner. | `string` | `null` | no | |
| <a name="enable_versioning"></a> [enable_versioning](#input\_enable\_versioning) | Flag to decide if bucket versioning is enabled. | `bool` | `false` | no | |
| <a name="versioning"></a> [versioning](#versioning) | S3 bucket Versioning Configuration | `map(string)` | `{}` | no | |
| <a name="enable_sse"></a> [enable_sse](#input\_enable\_sse) | Flag to decide if server side encryption is enabled. | `bool` | `false` | no | |
| <a name="create_kms_key"></a> [create_kms_key](#input\_create\_kms\_key) | Flag to decide if new KMS key (symmetric, encrypt/decrypt) is required for SSE-KMS encryption | `bool` | `false` | no | |
| <a name="server_side_encryption"></a> [server_side_encryption](#server\_side\_encryption) | Server Side Encryption Configuration | `map(string)` | `{}` | no | |
| <a name="bucket_public_access"></a> [bucket_public_access](#input\_bucket\_public\_access) | Manages S3 bucket-level Public Access | `map(bool)` | <pre>{<br>   block_public_acls       = true<br>   block_public_policy     = true<br>   ignore_public_acls      = true<br>   restrict_public_buckets = true<br>} | no | |
| <a name="default_tags"></a> [default_tags](#input\_default\_tags) | A map of tags to assign to all the resource. | `map(string)` | `{}` | no | |

## Nested Configuration Maps:  

#### versioning

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="status"></a> [status](#input\_status) | The versioning state of the bucket.<br>Possible Values:<br>&nbsp;&nbsp;&nbsp;`Enabled`<br>&nbsp;&nbsp;&nbsp;`Suspended`<br>&nbsp;&nbsp;&nbsp;`Disabled` | `string` | `Enabled` | no |
| <a name="mfa_delete"></a> [mfa_delete](#input\_mfa\_delete) | Flag to decide if MFA delete is enabled.<br>Possible Values:<br>&nbsp;&nbsp;&nbsp;`Enabled`<br>&nbsp;&nbsp;&nbsp;`Disabled` | `string` | `Disabled` | no |
| <a name="mfa"></a> [mfa](#input\_mfa) | The concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device. | `string` | `null` | no |

#### server_side_encryption

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="bucket_key_enabled"></a> [bucket_key_enabled](#input\_bucket\_key\_enabled) | Whether or not to use Amazon S3 Bucket Keys for SSE-KMS.<br>Possible Values:<br>&nbsp;&nbsp;&nbsp;`Enabled`<br>&nbsp;&nbsp;&nbsp;`Disabled` | `string` | `null` | no |
| <a name="sse_algorithm"></a> [sse_algorithm](#input\_sse\_algorithm) | The server-side encryption algorithm to use.<br>Possible Values:<br>&nbsp;&nbsp;&nbsp;`AES256`<br>&nbsp;&nbsp;&nbsp;`Disabled` | `string` | `"aws:kms"` | no |
| <a name="kms_key"></a> [kms_key](#input\_kms\_key) | The AWS KMS master key ID used for the SSE-KMS encryption. | `string` | `null` | no |

## Outputs

| Name | Type | Description |
|:------|:------|:------|
| <a name="id"></a> [id](#output\_id) | The name of the bucket. | `string` | 
| <a name="arn"></a> [arn](#output\_arn) | The ARN of the bucket. | `string` | 
| <a name="id"></a> [id](#output\_id) | The name of the bucket. | `string` | 
| <a name="kms_key"></a> [kms_key](#output\_kms\_key) | `map` | Attribute Map of KMS customer master key (CMK) to be used for encryption of the bucket objects.<br>&nbsp;&nbsp;&nbsp;`key_id` - The Key ID KSM Key.<br>&nbsp;&nbsp;&nbsp;`arn` - ARN of KMS Key<br>&nbsp;&nbsp;&nbsp;`policy` - KMS Key Policy. |

## Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-s3/graphs/contributors).

