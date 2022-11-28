## ARJ-Stack: AWS Simple Storage Service (S3) Terraform module

A Terraform module for configuring S3 buckets

### Resources
This module features the following components to be provisioned with different combinations:

- S3 Bucket [[aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)]
- S3 bucket- Canned ACL [[aws_s3_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl)]
- S3 Bucket- Public Access [[aws_s3_bucket_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)]
- S3 Bucket- CORS Configurations [[aws_s3_bucket_cors_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration)]
- S3 bucket- Versioning [[aws_s3_bucket_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning)]
- S3 Bucket- Server Side Encryption [[aws_s3_bucket_server_side_encryption_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration)]
- S3 Bucket- Transfer Acceleration [[aws_s3_bucket_accelerate_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_accelerate_configuration)]
- S3 Bucket- Policy [[aws_s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)]

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |

### Examples

Refer [Configuration Examples](https://github.com/arjstack/terraform-aws-examples/tree/main/aws-s3) for effectively utilizing this module.

### Inputs

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="create"></a> [create](#input\_create) | Flag to decide if the bucket is created | `bool` | `true` | no | |
| <a name="name"></a> [name](#input\_name) | The name of the bucket | `string` |  | yes | |
| <a name="force_destroy"></a> [force_destroy](#input\_force\_destroy) | Flag to decide if all objects (including any locked objects) should be deleted from the bucket so that the bucket can be destroyed without error | `bool` | `false` | no | |
| <a name="object_lock_enabled"></a> [object_lock_enabled](#input\_object\_lock\_enabled) | Flag to decide if this bucket has an Object Lock configuration enabled. | `bool` | `null` | no | |
| <a name="acl"></a> [acl](#input\_acl) | The canned ACL to apply to the bucket. | `string` | `null` | no | |
| <a name="grants"></a> [grants](#acl\_grants) | Set of grant configurations. | `set(map(string))` | `[]` | no | <pre>[<br>   {<br>     permission = "FULL_CONTROL"<br>     type = "CanonicalUser"<br>     id = "<Canonical User ID>"<br>   }<br>] |
| <a name="owner"></a> [owner](#input\_acl\_owner) | The Bucket Owner's configuration map. | `map(string)` | `{}` | no | |
| <a name="expected_bucket_owner"></a> [expected_bucket_owner](#input\_expected\_bucket\_owner) | The account ID of the expected bucket owner. | `string` | `null` | no | |
| <a name="enable_versioning"></a> [enable_versioning](#input\_enable\_versioning) | Flag to decide if bucket versioning is enabled. | `bool` | `false` | no | |
| <a name="versioning"></a> [versioning](#versioning) | S3 bucket Versioning Configuration | `map(string)` | `{}` | no | <pre>{<br>   status     = "Enabled"<br>   mfa_delete = "Enabled"<br>} |
| <a name="enable_sse"></a> [enable_sse](#input\_enable\_sse) | Flag to decide if server side encryption is enabled. | `bool` | `false` | no | |
| <a name="create_kms_key"></a> [create_kms_key](#input\_create\_kms\_key) | Flag to decide if new KMS key (symmetric, encrypt/decrypt) is required for SSE-KMS encryption | `bool` | `false` | no | |
| <a name="server_side_encryption"></a> [server_side_encryption](#server\_side\_encryption) | Server Side Encryption Configuration | `map(string)` | `{}` | no | <pre>{<br>   bucket_key_enabled = "Enabled"<br>   sse_algorithm      = "aws:kms"<br>} |
| <a name="bucket_public_access"></a> [bucket_public_access](#input\_bucket\_public\_access) | Manages S3 bucket-level Public Access | `map(bool)` | `{}` | no | <pre>{<br>   block_public_acls       = true<br>   block_public_policy     = true<br>   ignore_public_acls      = true<br>   restrict_public_buckets = true<br>} |
| <a name="cors_rules"></a> [cors_rules](#cors_rule) | List of CORS configuration maps | `any` | <pre>{<br>   allowed_headers = ["*"]<br>   allowed_methods = ["PUT", "POST"]<br>   allowed_origins = ["https://arjstack.com"]<br>   expose_headers  = ["ETag"]<br>   max_age_seconds = 3000<br>} | no | |
| <a name="transfer_acceleration"></a> [transfer_acceleration](#input\_transfer\_acceleration) | Sets the accelerate configuration of the bucket. Possible values are `Enabled` or `Suspended`. | `string` | `null` | no | |
| <a name="attach_bucket_policy"></a> [attach_bucket_policy](#input\_attach\_bucket\_policy) | Flag to decide if bucket policy should be attached to the bucket. | `bool` | `false` | no | |
| <a name="policy_file"></a> [policy_file](#input\_policy\_file) | Policy File name with path relative to root directory if `attach_bucket_policy` is set `true`. | `string` | `"policies/policy.json"` | no | |
| <a name="policy_content"></a> [policy_content](#input\_policy\_content) | Policy statements to be added to Bucket Policy if `attach_bucket_policy` is set `true`.. | `string` | `""` | no | |
| <a name="attach_policy_deny_insecure_transport"></a> [attach_policy_deny_insecure_transport](#input\_attach\_policy\_deny\_insecure\_transport) | Flag to decide for implementing bucket policy to deny bucket operations if in-transit data is not encrypted. | `bool` | `false` | no | |
| <a name="attach_policy_require_mfa"></a> [attach_policy_require_mfa](#input\_attach\_policy\_require\_mfa) | Flag to decide for implementing bucket policy to deny bucket operations if the request is not authenticated by using MFA. | `bool` | `false` | no | |
| <a name="default_tags"></a> [default_tags](#input\_default\_tags) | A map of tags to assign to all the resource. | `map(string)` | `{}` | no | |

### Nested Configuration Maps:  

#### acl_grants 

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="permission"></a> [permission](#input\_permission) | Logging permissions assigned to the grantee for the bucket. | `string` | `` | yes |
| <a name="id"></a> [id](#input\_id) | The canonical user ID of the grantee. | `string` | `null` | no |
| <a name="type"></a> [type](#input\_type) | Type of grantee. | `string` |  | yes |
| <a name="uri"></a> [uri](#input\_uri) | URI of the grantee group. | `string` | `null` | no |
| <a name="email"></a> [email](#input\_email) | Email address of the grantee. | `string` | `null` | no |

#### acl_owner 

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="id"></a> [id](#input\_id) | The ID of the owner. | `string` |  | yes |
| <a name="name"></a> [name](#input\_name) | The display name of the owner. | `string` | `null` | no |

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
| <a name="sse_algorithm"></a> [sse_algorithm](#input\_sse\_algorithm) | The server-side encryption algorithm to use.<br>Possible Values:<br>&nbsp;&nbsp;&nbsp;`AES256`<br>&nbsp;&nbsp;&nbsp;`aws:kms` | `string` | `"AES256"` | no |
| <a name="kms_key"></a> [kms_key](#input\_kms\_key) | The AWS KMS master key ID used for the SSE-KMS encryption. | `string` | `null` | no |

#### cors_rule

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="id"></a> [id](#input\_id) | Unique identifier for the rule. | `string` | `null` | no |
| <a name="allowed_headers"></a> [allowed_headers](#input\_allowed\_headers) | Set of Headers that are specified in the Access-Control-Request-Headers header. | `set(string)` | `null` | no |
| <a name="allowed_methods"></a> [allowed_methods](#input\_allowed\_methods) | Set of HTTP methods that you allow the origin to execute. | `set(string)` | `null` | no |
| <a name="allowed_origins"></a> [allowed_origins](#input\_allowed\_origins) | Set of origins you want customers to be able to access the bucket from. | `set(string)` | `null` | no |
| <a name="expose_headers"></a> [expose_headers](#input\_expose\_headers) | Set of headers in the response that you want customers to be able to access from their applications | `set(string)` | `null` | no |
| <a name="max_age_seconds"></a> [max_age_seconds](#input\_max\_age\_seconds) | The time in seconds that your browser is to cache the preflight response for the specified resource. | `number` | `null` | no |

### Outputs

| Name | Type | Description |
|:------|:------|:------|
| <a name="id"></a> [id](#output\_id) | The name of the bucket. | `string` | 
| <a name="arn"></a> [arn](#output\_arn) | The ARN of the bucket. | `string` | 
| <a name="region"></a> [region](#output\_region) | The AWS region this bucket resides in. | `string` | 
| <a name="kms_key"></a> [kms_key](#output\_kms\_key) | `map` | Attribute Map of KMS customer master key (CMK) to be used for encryption of the bucket objects.<br>&nbsp;&nbsp;&nbsp;`key_id` - The Key ID KSM Key.<br>&nbsp;&nbsp;&nbsp;`arn` - ARN of KMS Key<br>&nbsp;&nbsp;&nbsp;`policy` - KMS Key Policy. |

### Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-s3/graphs/contributors).

