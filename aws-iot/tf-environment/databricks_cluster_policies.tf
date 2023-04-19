locals {
  uc_enabled_policy = {
    "aws_attributes.instance_profile_arn" : {
      "type" : "fixed",
      "value" : "${resource.aws_iam_instance_profile.shared.arn}"
    },
    "data_security_mode" : {
      "type" : "fixed"
      "value" : "SINGLE_USER",
    }
    "node_type_id" : {
      "type" : "fixed",
      "value" : "${data.databricks_node_type.smallest.id}"
    },
    "driver_node_type_id" : {
      "type" : "fixed",
      "value" : "${data.databricks_node_type.smallest.id}"
    },
    "autotermination_minutes" : {
      "type" : "range",
      "maxValue" : 120
    },
    "custom_tags.UnityCatalogEnabled" : {
      "type" : "fixed",
      "value" : "true"
    }
  }
  uc_disabled_policy = {
    "aws_attributes.instance_profile_arn" : {
      "type" : "fixed",
      "value" : "${resource.aws_iam_instance_profile.shared.arn}"
    },
    "data_security_mode" : {
      "type" : "fixed",
      "value" : "NONE",
    }
    "node_type_id" : {
      "type" : "fixed",
      "value" : "${data.databricks_node_type.smallest.id}"
    },
    "driver_node_type_id" : {
      "type" : "fixed",
      "value" : "${data.databricks_node_type.smallest.id}"
    },
    "autotermination_minutes" : {
      "type" : "range",
      "maxValue" : 120
    },
    "custom_tags.UnityCatalogEnabled" : {
      "type" : "fixed",
      "value" : "false"
    }
  }

}

variable "small_job_cluster_overrides" {
  description = "Policy Overwrites to create small job clusters with enabled UC"
  default = {

    "cluster_type" : {
      "type" : "fixed",
      "value" : "job"
    },
    "custom_tags.clusterUsage" : {
      "type" : "fixed",
      "value" : "job"
    },
    "dbus_per_hour" : {
      "type" : "range",
      "maxValue" : 6
    },
  }
}


variable "single_node_job_cluster_overrides" {
  description = "Policy Overwrites to create small job clusters with enabled UC"
  default = {
    "cluster_type" : {
      "type" : "fixed",
      "value" : "job"
    },
    "custom_tags.clusterUsage" : {
      "type" : "fixed",
      "value" : "job"
    },
    "spark_conf.spark.databricks.cluster.profile" : {
      "type" : "fixed",
      "value" : "singleNode",
      "hidden" : true
    },
    "dbus_per_hour" : {
      "type" : "range",
      "maxValue" : 2
    },
  }
}

variable "all_purpose_cluster_overrides" {
  description = "Policy Overwrites to create all purpose clusters with enabled UC"
  default = {

    "cluster_type" : {
      "type" : "fixed",
      "value" : "all-purpose"
    },
    "custom_tags.clusterUsage" : {
      "type" : "fixed",
      "value" : "all-purpose"
    },
    "dbus_per_hour" : {
      "type" : "range",
      "maxValue" : 10
    },
  }
}

resource "databricks_cluster_policy" "uc_enabled_all_purpose_cluster_policy" {
  provider   = databricks.workspace
  name       = "UC-All-Purpose-Cluster-Policy"
  definition = jsonencode(merge(local.uc_enabled_policy, var.all_purpose_cluster_overrides))
}

resource "databricks_cluster_policy" "uc_enabled_small_cluster_job_policy" {
  provider   = databricks.workspace
  name       = "UC-Small-Job-Cluster-Policy"
  definition = jsonencode(merge(local.uc_enabled_policy, var.small_job_cluster_overrides))
}

resource "databricks_cluster_policy" "uc_enabled_single_node_cluster_job_policy" {
  provider   = databricks.workspace
  name       = "UC-Single-Node-Job-Cluster-Policy"
  definition = jsonencode(merge(local.uc_enabled_policy, var.single_node_job_cluster_overrides))
}

resource "databricks_cluster_policy" "uc_disabled_all_purpose_cluster_policy" {
  provider   = databricks.workspace
  name       = "nonUC-All-Purpose-Cluster-Policy"
  definition = jsonencode(merge(local.uc_disabled_policy, var.all_purpose_cluster_overrides))
}

resource "databricks_cluster_policy" "uc_disabled_small_cluster_job_policy" {
  provider   = databricks.workspace
  name       = "nonUC-Small-Job-Cluster-Policy"
  definition = jsonencode(merge(local.uc_disabled_policy, var.small_job_cluster_overrides))
}

resource "databricks_sql_global_config" "this" {
  provider             = databricks.workspace
  security_policy      = "DATA_ACCESS_CONTROL"
  instance_profile_arn = resource.databricks_instance_profile.shared.instance_profile_arn
}
