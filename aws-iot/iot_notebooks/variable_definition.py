# Databricks notebook source
demo_bucket = dbutils.secrets.get("demo_s3", "bucket_name")
landing_zone_without_uc = f"s3://{demo_bucket}/landing_without_uc"
bronze_path_without_uc = f"s3://{demo_bucket}/bronze_classic"
silver_path_without_uc = f"s3://{demo_bucket}/silver_classic"
gold_path_without_uc = f"s3://{demo_bucket}/gold_classic"
checkpoints_path_without_uc = f"s3://{demo_bucket}/checkpoints"
turbine_path = "/turbine_sensor"
weather_path = "/weather_sensor"
target_database = "iot_demo_classic"

# COMMAND ----------

from pyspark.sql.utils import ParseException


def get_path_to_landing_zone(landing_zone: str) -> str:
    path_to_landing_zone = landing_zone
    try:
        path_to_landing_zone = spark.sql("DESCRIBE EXTERNAL LOCATION landing_zone").select("url").collect()[0]["url"]
        return path_to_landing_zone
    except ParseException as e:
        if f"[UC_NOT_ENABLED] Unity Catalog is not enabled on this cluster" in str(e):
            return path_to_landing_zone
        else:
            raise e

path_to_landing_zone = get_path_to_landing_zone(landing_zone = landing_zone_without_uc)

# COMMAND ----------

def get_checkpoints(checkpoints_path: str) -> str:
    path_to_checkpoints = checkpoints_path
    try:
        path_to_checkpoints = spark.sql("DESCRIBE EXTERNAL LOCATION landing_zone").select("url").collect()[0]["url"]
        return f"{path_to_checkpoints}/checkpoints"
    except ParseException as e:
        if f"[UC_NOT_ENABLED] Unity Catalog is not enabled on this cluster" in str(e):
            return path_to_checkpoints
        else:
            raise e

path_to_checkpoints = get_checkpoints(checkpoints_path=checkpoints_path_without_uc)

# COMMAND ----------

def get_bronze_path(bronze_path: str) -> str:
    path_to_bronze = bronze_path
    try:
        path_to_bronze = spark.sql("DESCRIBE EXTERNAL LOCATION landing_zone").select("url").collect()[0]["url"] + "/bronze_classic"
        return path_to_bronze
    except ParseException as e:
        if f"[UC_NOT_ENABLED] Unity Catalog is not enabled on this cluster" in str(e):
            return path_to_bronze
        else:
            raise e

bronze_path = get_bronze_path(bronze_path=bronze_path_without_uc)

# COMMAND ----------

def get_silver_path(silver_path: str) -> str:
    path_to_silver = silver_path
    try:
        path_to_silver = spark.sql("DESCRIBE EXTERNAL LOCATION landing_zone").select("url").collect()[0]["url"] + "/silver_classic"
        return path_to_silver
    except ParseException as e:
        if f"[UC_NOT_ENABLED] Unity Catalog is not enabled on this cluster" in str(e):
            return path_to_silver
        else:
            raise e

silver_path = get_silver_path(silver_path=silver_path_without_uc)

# COMMAND ----------

def get_gold_path(gold_path: str) -> str:
    path_to_gold = gold_path
    try:
        path_to_gold = spark.sql("DESCRIBE EXTERNAL LOCATION landing_zone").select("url").collect()[0]["url"] + "/gold_classic"
        return path_to_gold
    except ParseException as e:
        if f"[UC_NOT_ENABLED] Unity Catalog is not enabled on this cluster" in str(e):
            return path_to_gold
        else:
            raise e

gold_path = get_gold_path(gold_path=gold_path_without_uc)