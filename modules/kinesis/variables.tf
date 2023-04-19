variable "tags" {
  type        = map(any)
  description = "(Optional) Map of tags to be applied to the kinesis stream"
}

variable "prefix" {
  type        = string
  description = "(Optional) Prefix for the resources deployed by this module"
}
