# Databricks notebook source
# MAGIC %run ./variable_definition

# COMMAND ----------

import pyspark.sql.functions as F
from pyspark.sql.types import *
from pyspark.sql.utils import AnalysisException
from datetime import datetime
import json

# COMMAND ----------

schema = StructType([
            StructField("deviceId", StringType()),
            StructField("timestamp", TimestampType()),
            StructField("angle", FloatType()),
            StructField("rpm", FloatType()),
            StructField("windspeed", FloatType()),
            StructField("temperature", FloatType()),
            StructField("humidity", FloatType()),
            StructField("winddirection", StringType()),
            ]
)

# COMMAND ----------

def get_last_reading(path: str) -> str:
    last_reading = None
    try:
        last_reading = spark.read.format("delta").load(f"{path}").select(F.max("approximateArrivalTimestamp").alias("last_reading")).collect()[0]["last_reading"]
        return last_reading
    except AnalysisException as e:
        if f"[PATH_NOT_FOUND] Path does not exist: {path}" in str(e):
            return last_reading
        else:
            raise e

def get_initial_position(turbine_reference: str, weather_reference: str) -> str:
    initial_position = "earliest"
    if ((turbine_reference == None) and (weather_reference == None)):
        pass
    elif ((turbine_reference == None) and (weather_reference != None)):
        timestamp = datetime.strftime(weather_reference, "%Y-%M-%d %H:%m:%S.%f")
        initial_position = str(json.dumps({"at_timestamp": f"{timestamp}", "format": "yyyy-MM-dd HH:mm:ss.SSSSSS"}))
    elif ((turbine_reference != None) and (weather_reference == None)):
        timestamp = datetime.strftime(turbine_reference, "%Y-%M-%d %H:%m:%S.%f")
        initial_position = str(json.dumps({"at_timestamp": f"{timestamp}", "format": "yyyy-MM-dd HH:mm:ss.SSSSSS"}))
    elif ((turbine_reference != None) and (weather_reference != None)):
        timestamp = datetime.strftime(max(turbine_reference, weather_reference), "%Y-%M-%d %H:%m:%S.%f")
        initial_position = str(json.dumps({"at_timestamp": f"{timestamp}", "format": "yyyy-MM-dd HH:mm:ss.SSSSSS"}))
    return initial_position

# COMMAND ----------

turbines_last_reading = get_last_reading(f"{bronze_path}{turbine_path}")
weather_last_reading = get_last_reading(f"{bronze_path}{weather_path}")

initial_position = get_initial_position(turbine_reference = turbines_last_reading, weather_reference = weather_last_reading)

# COMMAND ----------

initial_position

# COMMAND ----------

kinesis_stream_options = {
    "streamName": dbutils.secrets.get("kinesis_scope", "kinesis_stream_name"),
    "region": "us-west-1",
    "initialPosition": initial_position
}

# COMMAND ----------

kinesisDF = (
            spark.readStream
                .format("kinesis")
                .options(**kinesis_stream_options)
                .load()
                .withColumn("data", F.from_json(F.col("data").cast(StringType()), schema=schema))
                .select("approximateArrivalTimestamp", "data.*", F.to_date("data.timestamp").alias("date"))
            )

# COMMAND ----------

# MAGIC %md
# MAGIC # Split our IoT Hub stream into separate streams

# COMMAND ----------

turbineDF = (
                kinesisDF.where("deviceId <> 'WeatherCapture'")                                         # Filter out turbine telemetry from other data streams
                .select("approximateArrivalTimestamp", "deviceId", "date", "timestamp", "rpm", "angle") # Extract the fields of interest
            )

# COMMAND ----------

weatherDF = (
                kinesisDF.where("data.deviceId = 'WeatherCapture'")                                                                                              # Filter out turbine telemetry from other data streams
                .select("approximateArrivalTimestamp", "deviceId", "date", "timestamp", "windspeed", "angle", "temperature", "humidity", "rpm", "winddirection") # Extract the fields of interest
            )

# COMMAND ----------

# MAGIC %md
# MAGIC # Write them both into their own Delta locations

# COMMAND ----------

write_turbine_to_delta = (
    turbineDF
    .writeStream.format('delta')                                                  # Write our stream to the Delta format
    .option("checkpointLocation", f"{path_to_checkpoints}/{turbine_path}")     # Checkpoint so we can restart streams gracefully
    .start(f"{bronze_path}{turbine_path}")                                         # Stream the data into an S3 Path
)

# COMMAND ----------

write_weather_to_delta = (
      weatherDF
    .writeStream.format('delta')                                                  # Write our stream to the Delta format
    .option("checkpointLocation", f"{path_to_checkpoints}/{weather_path}")     # Checkpoint so we can restart streams gracefully
    .start(f"{bronze_path}{weather_path}")                                         # Stream the data into an S3 Path
)

# COMMAND ----------

# MAGIC %md
# MAGIC # Create database in hive metastore

# COMMAND ----------

spark.sql(f"""CREATE DATABASE IF NOT EXISTS {target_database}_raw""")

# COMMAND ----------

# Create the external tables once data starts to stream in
while True:
    try:
        spark.sql(f"CREATE TABLE IF NOT EXISTS {target_database}_raw.turbine_sensor USING DELTA LOCATION '{bronze_path}{turbine_path}'")
        spark.sql(f"CREATE TABLE IF NOT EXISTS {target_database}_raw.weather_sensor USING DELTA LOCATION '{bronze_path}{weather_path}'")
        break
    except Exception as e:
        print("Error, trying again in 3 seconds")
        print(e)
        sleep(3)
    pass

# COMMAND ----------

# MAGIC %md
# MAGIC # Check bronze data

# COMMAND ----------

spark.sql(f"select * from {target_database}_raw.turbine_sensor").display()

# COMMAND ----------

spark.sql(f"select * from {target_database}_raw.weather_sensor").display()

# COMMAND ----------

# MAGIC %md
# MAGIC #Save data into Delta tables

# COMMAND ----------

# Create functions to merge turbine and weather data into their target Delta tables
def merge_delta(incremental, target): 
    incremental.dropDuplicates(['date','window','deviceid']).createOrReplaceTempView("incremental")
  
    try:
        # MERGE records into the target table using the specified join key
        incremental._jdf.sparkSession().sql(f"""
          MERGE INTO delta.`{target}` t
          USING incremental i
          ON i.date=t.date AND i.window = t.window AND i.deviceId = t.deviceid
          WHEN MATCHED THEN UPDATE SET *
          WHEN NOT MATCHED THEN INSERT *
        """)
    except:
        # If the †arget table does not exist, create one
        incremental.write.format("delta").partitionBy("date").save(target)

# COMMAND ----------

turbine_bronze_to_silver = (
  spark.readStream.format('delta').table(f"{target_database}_raw.turbine_sensor")
    .withColumn("window", F.window("timestamp", "10 minutes")["start"])
    .groupby("date", "window", "deviceId")
    .agg(
      F.avg("rpm").alias("rpm"), 
      F.avg("angle").alias("angle")
    )  
    .writeStream
    .foreachBatch(lambda i, b: merge_delta(i, f"{silver_path}/turbine_sensor_agg"))
    .outputMode("update")
    .option("checkpointLocation", f"{path_to_checkpoints}/silver/turbine_sensor_agg")
    .start()
)

# COMMAND ----------

weather_bronze_to_silver = (
  spark.readStream.format('delta').table(f"{target_database}_raw.weather_sensor")
  .withColumn("window", F.window("timestamp", "10 minutes")["start"])
  .groupby("date", "window", "deviceId")
  .agg(
      F.avg("temperature").alias("temperature"), 
      F.avg("humidity").alias("humidity"),
      F.avg("windspeed").alias("windspeed"),
      F.last("winddirection").alias("winddirection")
  )
  .writeStream
  .foreachBatch(lambda i, b: merge_delta(i, f"{silver_path}/weather_sensor_agg"))
  .outputMode("update")
  .option("checkpointLocation",  f"{path_to_checkpoints}/silver/weather_sensor_agg")
  .start()
)

# COMMAND ----------

spark.sql(f"select * from delta.`{silver_path}/turbine_sensor_agg`").limit(10).display()

# COMMAND ----------

# spark.sql(f"DROP TABLE IF EXISTS {target_database}.turbine_sensor_agg")
# spark.sql(f"DROP TABLE IF EXISTS {target_database}.weather_sensor_agg")

# COMMAND ----------

# Create the external tables once data starts to stream in
while True:
    try:
        spark.sql(f'CREATE TABLE IF NOT EXISTS hive_metastore.{target_database}.turbine_sensor_agg USING DELTA LOCATION "{silver_path}/turbine_sensor_agg"')
        spark.sql(f'CREATE TABLE IF NOT EXISTS hive_metastore.{target_database}.weather_sensor_agg USING DELTA LOCATION "{silver_path}/weather_sensor_agg"')
        break
    except Exception as e:
        print("Error, trying again in 3 seconds")
        print(e)
        sleep(3)
    pass

# COMMAND ----------

# MAGIC %md
# MAGIC #Check Silver data

# COMMAND ----------

spark.sql(f"select * from {target_database}.turbine_sensor_agg").display()

# COMMAND ----------

spark.sql(f"select * from {target_database}.weather_sensor_agg").display()