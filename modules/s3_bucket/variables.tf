variable "tags" {
  type        = map(any)
  description = "(Optional) Map of tags to be applied to the kinesis stream"
}

variable "bucket_name" {
  type        = string
  description = "(Optional) Name for the bucket managed by this module"
  default     = null
}

resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 8
}

locals {
  bucket_name = var.bucket_name == null ? "${resource.random_string.naming.result}-s3-bucket" : var.bucket_name
}