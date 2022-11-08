variable "name" {
    description  = "The name of the bucket"
    type = string
}

variable "force_destroy" {
    description = <<EOF
Flag to decide if all objects (including any locked objects) should be 
deleted from the bucket so that the bucket can be destroyed without error
EOF
    type        = bool
    default     = false
}

variable "object_lock_enabled" {
    description = "Flag to decide if this bucket has an Object Lock configuration enabled."
    type        = bool
    default     = null
}

variable "acl" {
    description = "The canned ACL to apply to the bucket."
    type        = string
    default     = "private"
}

variable "expected_bucket_owner" {
    description = "The account ID of the expected bucket owner."
    type        = string
    default     = null
}

variable "enable_versioning" {
    description = "Flag to decide if bucket versioning is enabled."
    type        = bool
    default     = false
}

variable "versioning" {
    description = <<EOF
S3 bucket Versioning Configuration
status: The versioning state of the bucket.
mfa_delete: Flag to decide if MFA delete is enabled.
mfa: The concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device.
EOF
    type = map(string)
    default = {}

    validation {
        condition     = contains(["Enabled", "Suspended", "Disabled"], lookup(var.versioning, "status", "Enabled"))
        error_message = "Possible values are `Enabled`, `Suspended` and `Disabled`."
    }

    validation {
        condition     = contains(["Enabled", "Disabled"], lookup(var.versioning, "mfa_delete", "Disabled"))
        error_message = "Possible values are `Enabled` and `Disabled`."
    }
}

variable "enable_sse" {
    description = "Flag to decide if server side encryption is enabled."
    type        = bool
    default     = false
}

variable "create_kms_key" {
    description = "Flag to decide if new KMS key (symmetric, encrypt/decrypt) is required for SSE-KMS encryption"
    type        = bool
    default     = false
}

variable "server_side_encryption" {
    description = <<EOF
Server Side Encryption Configuration

bucket_key_enabled: Flag to decide if use Amazon S3 Bucket Keys for SSE-KMS.
sse_algorithm: The server-side encryption algorithm to use.
kms_key: The AWS KMS master key ID used for the SSE-KMS encryption.
EOF
    type = map(any)
    default = {}
    
    validation {
        condition     = contains(["AES256", "aws:kms"], lookup(var.server_side_encryption, "sse_algorithm", "AES256"))
        error_message = "Possible values are `AES256` and `aws:kms`."
    }
}

variable "bucket_public_access" {
    description = <<EOF
Manages S3 bucket-level Public Access

block_public_acls       : Block public access to buckets and objects granted through new access control lists (ACLs)
block_public_policy     : Block public access to buckets and objects granted through new public bucket policies
ignore_public_acls      : Block public access to buckets and objects granted through any access control lists (ACLs)
restrict_public_buckets : Block public and cross-account access to buckets and objects through any public bucket policies
EOF
    type = map(bool)
    default = {
        block_public_acls       = true
        block_public_policy     = true
        ignore_public_acls      = true
        restrict_public_buckets = true
    }

}

variable "cors_rules" {
    description = <<EOF
List of CORS configuration maps where each entry is map with following kay-pairs

id: (Optional) Unique identifier for the rule.
allowed_headers: (Optional) Set of Headers that are specified in the Access-Control-Request-Headers header.
allowed_methods: (Required) Set of HTTP methods that you allow the origin to execute.
allowed_origins: (Required) Set of origins you want customers to be able to access the bucket from.
expose_headers: (Optional) Set of headers in the response that you want customers to be able to access from their applications
max_age_seconds: (Optional) The time in seconds that your browser is to cache the preflight response for the specified resource.

EOF
    type = any
    default = []
}
variable "default_tags" {
    description = "(Optional) A map of tags to assign to all the resource."
    type = map(string)
    default = {}
}