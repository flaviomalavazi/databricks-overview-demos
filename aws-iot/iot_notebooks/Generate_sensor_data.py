# Databricks notebook source
import boto3
import json
from datetime import datetime, timedelta
import logging
from random import randint, random, gauss, choice
from uuid import uuid4
from typing import List
from time import sleep

logger = logging.getLogger()
logging.basicConfig(level=logging.INFO)


# COMMAND ----------

from json import dumps
from datetime import datetime
from random import gauss, choice

class kinesisProducer():
    from json import dumps
    from datetime import datetime
    from random import gauss, choice
    
    def __init__(self, stream_name: str, region_name: str):
        self.client = boto3.client("kinesis",
                       region_name=region_name)
        self.kinesis_stream_name = stream_name

    def put_kinesis_record(self, measurement: dict) -> None:
        self.client.put_record(
                    StreamName=self.kinesis_stream_name,
                    Data=(dumps(measurement) + "\n"),
                    PartitionKey=datetime.strftime(datetime.now(), "%Y%m%d")
                )
        
    def generate_weather_message(self) -> dict:
        measurement = {
            "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f").strip()[:-2],
            "deviceId": "WeatherCapture",
            "temperature": gauss(28, 5),
            "humidity": gauss(50, 25),
            "windspeed": gauss(20,10),
            "winddirection": choice(["N", "NW", "W", "SW", "S", "NE", "SE", "E"]),
            "rpm": gauss(15,5),
            "angle": gauss(7,2),
        }
        return measurement

    def generate_turbine_message(self) -> dict:
        measurement = {
            "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f").strip()[:-2],
            "deviceId": choice(["WindTurbine-1","WindTurbine-2","WindTurbine-3","WindTurbine-4","WindTurbine-5","WindTurbine-6","WindTurbine-7","WindTurbine-8","WindTurbine-9","WindTurbine-10"]),
            "rpm": gauss(15,5),
            "angle": gauss(7,2),
        }
        return measurement
    
    def put_message(self, message_type: str) -> None:
        if message_type == "turbine":
            self.put_kinesis_record(measurement = self.generate_turbine_message())
        elif message_type == "weather":
            self.put_kinesis_record(measurement = self.generate_weather_message())
        else:
            pass

# COMMAND ----------

kinesis = kinesisProducer(stream_name = dbutils.secrets.get("kinesis_scope", "kinesis_stream_name"), region_name = "us-west-1")

# COMMAND ----------

session = boto3.Session(region_name="us-west-1")
credentials = session.get_credentials()
# credentials = credentials.get_frozen_credentials()

# COMMAND ----------

type(credentials)

# COMMAND ----------

a = 10
while (a>=0):
    turbine_measurements = 0
    while turbine_measurements <= 10:
        kinesis.put_message(message_type="turbine")
        turbine_measurements = turbine_measurements + 1
    kinesis.put_message(message_type="weather")
    a = a-1

# COMMAND ----------

print(f"Begin streaming at: {datetime.now()}")
for i in range(1,1000):
    for meter in meters:
        measurement = meter.measure()
        if measurement != {}:
            client.put_record(
                StreamName=secrets.kinesisStreamName,
                Data=(json.dumps(measurement) + "\n"),
                PartitionKey=datetime.strftime(datetime.now(), "%Y%m%d")
            )
        sleep(0.1)

print(f"Done streaming at: {datetime.now()}")

# COMMAND ----------

stream_name = dbutils.secrets.get("kinesis_scope", "kinesis_stream_name")
region_name = "us-west-1"

# COMMAND ----------

spark.conf.set("spark.databricks.kinesis.listShards.enabled", "false")

# COMMAND ----------

kinesisDF = (spark.readStream
  .format("kinesis")
  .option("streamName", stream_name)
  .option("region", region_name)
  .option("initialPosition", "earliest")
  .load())

# COMMAND ----------

kinesisDF.display()

# COMMAND ----------

# MAGIC %sql
# MAGIC select * from temporaria
