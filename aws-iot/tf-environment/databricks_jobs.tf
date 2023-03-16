

resource "databricks_job" "create_and_write_data_to_mysql" {
  provider = databricks.workspace
  webhook_notifications {
  }
  task {
    task_key = "Create_and_write_data_to_MySQL"
    notebook_task {
      source        = "WORKSPACE"
      notebook_path = "/iot_demo/01a_Write_data_to_MySQL"
    }
    job_cluster_key = "Write_data_to_MySQL"
    email_notifications {
    }
  }
  task {
    task_key = "Read_data_from_MySQL_to_LZ"
    notebook_task {
      source        = "WORKSPACE"
      notebook_path = "/iot_demo/02a_Read_data_from_MySQL_to_landing_zone"
    }
    job_cluster_key = "Read_data_from_MySQL_to_s3"
    email_notifications {
    }
    depends_on {
      task_key = "Create_and_write_data_to_MySQL"
    }
  }
  name = "Create_and_write_data_to_MySQL"
  job_cluster {
    new_cluster {
      spark_version = "12.2.x-scala2.12"
      spark_env_vars = {
        PYSPARK_PYTHON = "/databricks/python3/bin/python3"
      }
      runtime_engine              = "STANDARD"
      policy_id                   = databricks_cluster_policy.uc_disabled_small_cluster_job_policy.id
      apply_policy_default_values = true
      num_workers                 = 2
      node_type_id                = "m5d.large"
      data_security_mode          = "NONE"
      aws_attributes {
        zone_id                = "auto"
        spot_bid_price_percent = 100
        instance_profile_arn   = resource.databricks_instance_profile.shared.id
        first_on_demand        = 1
        availability           = "SPOT_WITH_FALLBACK"
      }
    }
    job_cluster_key = "Read_data_from_MySQL_to_s3"
  }
  job_cluster {
    new_cluster {
      spark_version = "12.2.x-scala2.12"
      spark_conf = {
        "spark.databricks.cluster.profile" = "singleNode"
        "spark.master"                     = "local[*, 4]"
      }
      runtime_engine              = "STANDARD"
      policy_id                   = databricks_cluster_policy.uc_enabled_single_node_cluster_job_policy.id
      apply_policy_default_values = true
      node_type_id                = "m5d.large"
      enable_elastic_disk         = true
      data_security_mode          = "SINGLE_USER"
      custom_tags = {
        ResourceClass       = "SingleNode"
        UnityCatalogEnabled = "true"
        clusterUsage        = "job"
      }
      aws_attributes {
        zone_id                = "auto"
        spot_bid_price_percent = 100
        instance_profile_arn   = resource.databricks_instance_profile.shared.id
        first_on_demand        = 1
        availability           = "SPOT_WITH_FALLBACK"
      }
    }
    job_cluster_key = "Write_data_to_MySQL"
  }
  email_notifications {
  }

  depends_on = [
    resource.databricks_notebook.iot_demo_notebooks
  ]

}

resource "databricks_job" "write_data_to_kinesis" {
  provider = databricks.workspace
  webhook_notifications {
  }
  task {
    task_key = "Write_data_to_kinesis"
    notebook_task {
      source        = "WORKSPACE"
      notebook_path = "/iot_demo/01b_Generate_sensor_data"
    }
    job_cluster_key = "Read_data_from_kinesis_cluster"
    email_notifications {
    }
  }
  name = "Write_data_to_kinesis"
  job_cluster {
    new_cluster {
      spark_version               = "12.2.x-scala2.12"
      runtime_engine              = "STANDARD"
      policy_id                   = databricks_cluster_policy.uc_disabled_small_cluster_job_policy.id
      apply_policy_default_values = true
      node_type_id                = "m5d.large"
      data_security_mode          = "NONE"
      custom_tags = {
        UnityCatalogEnabled = "false"
        clusterUsage        = "job"
      }
      aws_attributes {
        zone_id                = "us-west-1b"
        spot_bid_price_percent = 100
        instance_profile_arn   = resource.databricks_instance_profile.shared.id
        first_on_demand        = 1
        availability           = "SPOT_WITH_FALLBACK"
      }
      autoscale {
        min_workers = 2
        max_workers = 3
      }
    }
    job_cluster_key = "Read_data_from_kinesis_cluster"
  }
  email_notifications {
  }
  depends_on = [
    resource.databricks_notebook.iot_demo_notebooks
  ]
}
