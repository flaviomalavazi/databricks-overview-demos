resource "databricks_instance_profile" "shared" {
  provider             = databricks.workspace
  instance_profile_arn = resource.aws_iam_instance_profile.shared.arn
}

# Get the smallest cluster node possible on that cloud
data "databricks_node_type" "smallest" {
  provider   = databricks.workspace
  local_disk = true
  depends_on = [module.databricks_workspace]
}

# Get the latest LTS Version for Databricks Runtime
data "databricks_spark_version" "latest_version" {
  provider          = databricks.workspace
  long_term_support = true
  depends_on        = [module.databricks_workspace]
}

resource "databricks_cluster" "unity_catalog_cluster" {
  provider                    = databricks.workspace
  cluster_name                = "Demo Cluster"
  spark_version               = data.databricks_spark_version.latest_version.id
  node_type_id                = data.databricks_node_type.smallest.id
  apply_policy_default_values = true
  data_security_mode          = "USER_ISOLATION"
  autotermination_minutes     = 120
  aws_attributes {
    availability           = "SPOT"
    instance_profile_arn   = resource.aws_iam_instance_profile.shared.arn
    first_on_demand        = 1
    spot_bid_price_percent = 100
  }

  depends_on = [
    module.databricks_workspace
  ]

  autoscale {
    min_workers = 1
    max_workers = 5
  }

  spark_conf = {
    "spark.databricks.io.cache.enabled" : true,
    "spark.databricks.io.cache.maxDiskUsage" : "50g",
    "spark.databricks.io.cache.maxMetaDataCache" : "1g",
    "spark.databricks.unityCatalog.userIsolation.python.preview" : true
  }

  custom_tags = {
    "ClusterScope" = "Initial Demo"
  }

}


resource "databricks_cluster" "streaming_cluster" {
  provider                    = databricks.workspace
  cluster_name                = "Streaming Cluster"
  spark_version               = data.databricks_spark_version.latest_version.id
  node_type_id                = data.databricks_node_type.smallest.id
  apply_policy_default_values = true
  data_security_mode          = "NONE"
  autotermination_minutes     = 120
  aws_attributes {
    availability           = "SPOT"
    instance_profile_arn   = resource.aws_iam_instance_profile.shared.arn
    first_on_demand        = 1
    spot_bid_price_percent = 100
  }

  depends_on = [
    module.databricks_workspace
  ]

  autoscale {
    min_workers = 1
    max_workers = 3
  }

  spark_conf = {
    "spark.databricks.io.cache.enabled" : true,
    "spark.databricks.io.cache.maxDiskUsage" : "50g",
    "spark.databricks.io.cache.maxMetaDataCache" : "1g",
    "spark.databricks.unityCatalog.userIsolation.python.preview" : true
  }

  custom_tags = {
    "ClusterScope" = "Initial Demo"
  }

}


# resource "databricks_sql_endpoint" "demo_sql_warehouse" {
#   provider         = databricks.workspace
#   name             = "Demo Warehouse"
#   cluster_size     = "X-Small"
#   warehouse_type   = "PRO"
#   max_num_clusters = 1
#   auto_stop_mins   = 30

#   tags {
#     custom_tags {
#       key   = "clusterUsage"
#       value = "SQL"
#     }
#   }

# }
