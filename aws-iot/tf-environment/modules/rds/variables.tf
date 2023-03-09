variable "tags" {
  type        = map(any)
  description = "(Optional) Map of tags to be applied to the kinesis stream"
}

variable "prefix" {
  type        = string
  description = "(Optional) Prefix for the resources deployed by this module"
}

variable "region" {
  type        = string
  description = "(Required) AWS region where the resources will be deployed"
}

variable "rds_cidr_block" {
  type        = string
  description = "(Optional) Prefix for the resources deployed by this module"
  default     = "192.168.0.1"
}

variable "rds_admin_username" {
  type        = string
  description = "(Required) RDS admin username"
}

variable "rds_admin_password" {
  type        = string
  description = "(Required) RDS admin password"
}

variable "db_name" {
  type        = string
  description = "(Required) Name of the MySql database"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "(Required) List of security group IDs that will be associated with the RDS"
}

locals {
  public_subnets = [cidrsubnet(var.rds_cidr_block, 3, 0)]
  private_subnets = [cidrsubnet(var.rds_cidr_block, 3, 1), cidrsubnet(var.rds_cidr_block, 3, 2)]
}