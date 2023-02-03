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

variable "prefix" {
  type = string
}

variable "suffix" {
  type = string
}

variable "firewallfqdn" {
  type = list(any)
}

variable "resource_group_name" {
  type = string
}

# variable "tags" {
#   type = map
# }

locals {
  // dltp - databricks labs terraform provider
  location          = local.rglocation
  cidr              = local.spokecidr
  dbfsname          = join("", [local.dbfs_prefix, local.suffix]) // dbfs name must not have special chars
  resourcegroupname = var.resource_group_name
  prefix            = var.prefix
  suffix            = var.suffix
  hubcidr           = var.hubcidr
  spokecidr         = var.spokecidr
  no_public_ip      = var.no_public_ip
  rglocation        = var.rglocation
  metastore_hosts   = var.metastore_hosts
  dbfs_prefix       = var.dbfs_prefix
  firewallfqdn      = var.firewallfqdn
  tags              = var.tags
}
