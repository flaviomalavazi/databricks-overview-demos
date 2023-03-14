# Databricks notebook source
# MAGIC %md
# MAGIC 
# MAGIC # Write data from Databricks to MySQL
# MAGIC 
# MAGIC This notebook shows you how to write data from Databricks to a MySQL RDS using a JDBC using Python.

# COMMAND ----------

import pandas as pd
from itertools import islice, product
from datetime import datetime, timedelta
from random import randrange, random, choice
from pyspark.sql.types import *
import pyspark.sql.functions as F

turbines = ["WindTurbine-1",
            "WindTurbine-2",
            "WindTurbine-3",
            "WindTurbine-4",
            "WindTurbine-5",
            "WindTurbine-6",
            "WindTurbine-7",
            "WindTurbine-8",
            "WindTurbine-9",
            "WindTurbine-10"]

hour_range = 24

days_to_subtract = 90
days_ahead = 7

begin_date = datetime.today() - timedelta(days=days_to_subtract)
delta = (datetime.today() + timedelta(days=days_ahead)) - begin_date
end_date = datetime.strftime((begin_date + timedelta(days=(delta.days+1))), "%Y-%m-%d")

measurement_times = [x for x in pd.date_range(start= pd.Timestamp(begin_date).round('10T'), end = pd.Timestamp(end_date).round('10T'), freq="10T")]
measurement_dates = set([x.date() for x in measurement_times])

turbine_measurement_dates = list(product(turbines, measurement_dates))
turbine_measurement_times = list(product(turbines, measurement_times))

maintenance_data = [(x[0], x[1], choice([0, 0, 0, 0, 0, 0, 0, 1])) for x in turbine_measurement_dates]
power_data = [(x[0], x[1].date(), datetime.fromtimestamp(x[1].timestamp()).strftime('%Y-%m-%d %H:%M:%S'), round(randrange(0,300)+random(),5)) for x in turbine_measurement_times]

# COMMAND ----------

maintenance_header_schema = StructType([
  StructField('deviceId', StringType(), True),
  StructField('date', DateType(), True),
  StructField('maintenance', IntegerType(), True)
  ])

maintenance_header_df = spark.createDataFrame(maintenance_data, maintenance_header_schema)

# COMMAND ----------

power_schema = StructType([
  StructField('deviceId', StringType(), True),
  StructField('date', DateType(), True),
  StructField('window', StringType(), True),
  StructField('power', FloatType(), True)
  ])

power_df = spark.createDataFrame(power_data, power_schema).withColumn("window", F.unix_timestamp(F.col("window"),'yyyy-MM-dd HH:mm:ss').cast("timestamp"))

# COMMAND ----------

# MAGIC %md
# MAGIC 
# MAGIC ## Step 1: Connection information
# MAGIC 
# MAGIC First define some variables to programmatically create these connections.
# MAGIC 
# MAGIC Replace all the variables in angle brackets `<>` below with the corresponding information.

# COMMAND ----------

driver = "org.mariadb.jdbc.Driver"

database_host = dbutils.secrets.get("rds_scope", "host")
database_port = dbutils.secrets.get("rds_scope", "port")
database_name = dbutils.secrets.get("rds_scope", "database")
user = dbutils.secrets.get("rds_scope", "username")
password = dbutils.secrets.get("rds_scope", "password")

url = f"jdbc:mysql://{database_host}:{database_port}/{database_name}"

# COMMAND ----------

# MAGIC %md
# MAGIC # Write the data to the MySQL RDS
# MAGIC Now we write the data to the MySQL RDS using spark and the org.mariadb.jdbc driver.
# MAGIC 
# MAGIC We replace the table on RDS if it already exists because this is a demo.

# COMMAND ----------

table = "maintenance_data"

(
  maintenance_header_df.write.mode("overwrite")
                      .format("jdbc")
                      .option("driver", driver)
                      .option("url", url)
                      .option("dbtable", table)
                      .option("user", user)
                      .option("password", password)
                      .save()
)

# COMMAND ----------

table = "power_output"

(
  power_df.write.mode("overwrite")
                      .format("jdbc")
                      .option("driver", driver)
                      .option("url", url)
                      .option("dbtable", table)
                      .option("user", user)
                      .option("password", password)
                      .save()
)