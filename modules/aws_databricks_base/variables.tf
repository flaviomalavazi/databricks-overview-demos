variable "tags" {
  type        = map(any)
  description = "(Required) Map of tags to be applied to the kinesis stream"
}

variable "prefix" {
  type        = string
  description = "(Required) Prefix for the resources deployed by this module"
}

variable "cidr_block" {
  type        = string
  description = "(Required) CIDR block for the VPC that will be used to create the Databricks workspace"
}

variable "region" {
  type        = string
  description = "(Required) AWS region where the resources will be deployed"
}