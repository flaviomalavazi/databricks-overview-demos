# Databricks notebook source
# MAGIC %md
# MAGIC 
# MAGIC # Load data from MySQL to Delta Lake
# MAGIC 
# MAGIC This notebook shows you how to import data from JDBC MySQL databases into a Delta Lake table using Python.

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
# MAGIC 
# MAGIC ## Step 2: Reading the data
# MAGIC 
# MAGIC Now that you've specified the file metadata, you can create a DataFrame. Use an *option* to infer the data schema from the file. You can also explicitly set this to a particular schema if you have one already.
# MAGIC 
# MAGIC First, create a DataFrame in Python, referencing the variables defined above.

# COMMAND ----------

query = f"""SELECT * FROM information_schema.tables where TABLE_SCHEMA = '{database_name}'"""

tableDF = (
            spark.read
            .format("jdbc")
            .option("driver", driver)
            .option("url", url)
            .option("query", query)
            .option("user", user)
            .option("password", password)
            .load()
            )

tables = list(set([row['TABLE_NAME'] for row in tableDF.collect()]))

table_list = "','".join(tables)

# COMMAND ----------

tableData = {}
for table in tables:
    print(table)
    # Read from SQL Table
    tableData[table] = {}
    tableData[table]['schema'] = database_name
    tableData[table]['data'] = (
                                    spark.read
                                    .format("jdbc")
                                    .option("driver", driver)
                                    .option("url", url)
                                    .option("dbtable", table)
                                    .option("user", user)
                                    .option("password", password)
                                    .load()
                                )

# COMMAND ----------

# MAGIC %md
# MAGIC 
# MAGIC ## Step 3: Create a Delta table
# MAGIC 
# MAGIC The DataFrame defined and displayed above is a temporary connection to the remote database.
# MAGIC 
# MAGIC To ensure that this data can be accessed by relevant users througout your workspace, save it as a Delta Lake table using the code below.

# COMMAND ----------

number_of_tables = len(tables)
print(f"Saving {number_of_tables} tables to Unity Catalog...")
spark.sql("CREATE CATALOG IF NOT EXISTS landing;")
spark.sql("USE CATALOG landing;")
spark.sql(f"CREATE SCHEMA IF NOT EXISTS {database_name}_raw;")
spark.sql(f"USE SCHEMA {database_name}_raw;")
for table in tableData.keys():
    tableData[table]['data'].write.mode("overwrite").saveAsTable(table)
