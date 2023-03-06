# data "aws_iam_instance_profile" "ec2_databricks_instance_profile" {
#   name = var.databricks_ec2_instance_profile_name
# }

# resource "databricks_instance_profile" "demo_instance_profile" {
#   instance_profile_arn = data.aws_iam_instance_profile.ec2_databricks_instance_profile.arn
# }

# # Get the smallest cluster node possible on that cloud
# data "databricks_node_type" "smallest" {
#   local_disk = true
#   depends_on = [module.databricks_workspace]
# }

# # Get the latest LTS Version for Databricks Runtime
# data "databricks_spark_version" "latest_version" {
#   long_term_support = true
#   depends_on        = [module.databricks_workspace]
# }

# resource "databricks_cluster" "first_cluster" {
#   cluster_name                = "Demo Cluster"
#   spark_version               = data.databricks_spark_version.latest_version.id
#   node_type_id                = data.databricks_node_type.smallest.id
#   policy_id                   = resource.databricks_instance_profile.demo_instance_profile.id
#   apply_policy_default_values = true
#   data_security_mode          = "NONE"
#   autotermination_minutes     = 120
#   depends_on = [
#     module.databricks_workspace
#   ]

#   autoscale {
#     min_workers = 1
#     max_workers = 5
#   }

#   spark_conf = {
#     "spark.databricks.io.cache.enabled" : true,
#     "spark.databricks.io.cache.maxDiskUsage" : "50g",
#     "spark.databricks.io.cache.maxMetaDataCache" : "1g",
#     "spark.databricks.unityCatalog.userIsolation.python.preview" : true
#   }

#   library {
#     pypi {
#       package = "sqlalchemy"
#     }
#   }

#   custom_tags = {
#     "ClusterScope" = "Initial Demo"
#   }

# }
