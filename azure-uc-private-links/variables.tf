resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}

variable "hubcidr" {
  type = string
}

variable "spokecidr" {
  type = string
}

variable "no_public_ip" {
  type = bool
}

variable "rglocation" {
  type = string
}

variable "metastore_hosts" {
  type = list(string)
}

variable "dbfs_prefix" {
  type = string
}

variable "workspace_prefix" {
  type = string
}

variable "firewallfqdn" {
  type = list(any)
}

variable "prefix" {
  type = string
}

locals {
  prefix              = var.prefix
  suffix              = resource.random_string.naming.result
  resource_group_name = "${var.prefix}-${resource.random_string.naming.result}-rg"
  hubcidr             = var.hubcidr
  spokecidr           = var.spokecidr
  no_public_ip        = var.no_public_ip
  rglocation          = var.rglocation
  metastore_hosts     = var.metastore_hosts
  dbfs_prefix         = var.dbfs_prefix
  workspace_prefix    = var.workspace_prefix
  firewallfqdn        = var.firewallfqdn
  // tags that are propagated down to all resources
  tags = {
    Environment = "Testing"
    Owner       = lookup(data.external.me.result, "name")
    Epoch       = resource.random_string.naming.result
  }
}