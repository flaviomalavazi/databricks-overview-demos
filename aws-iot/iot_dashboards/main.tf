# resource "databricks_sql_query" "gold_table_query_check" {
#   parent = "folders/iot_dashboards/queries"
#   query          = <<EOT
#                     SELECT
#                       sensor.*,
#                       weather.temperature, 
#                       weather.humidity, 
#                       weather.windspeed, 
#                       weather.winddirection,
#                       maint.maintenance,
#                       power.power
#                     FROM
#                       hive_metastore.dlt_demo.silver_agg_turbine_data sensor
#                       INNER JOIN hive_metastore.dlt_demo.silver_agg_weather_data weather
#                         ON sensor.`date` = weather.`date` AND sensor.`window` = weather.`window`
#                       INNER JOIN hive_metastore.dlt_demo.silver_maintenance_data maint
#                         ON sensor.`date` = maint.`date` and sensor.devicedata_source_id = maint.deviceid
#                       INNER JOIN hive_metastore.dlt_demo.silver_poweroutput_data power
#                       ON sensor.`date` = power.`date` AND sensor.`window` = power.`window` AND sensor.devicedata_source_id = power.deviceid 
#                 EOT
#   name           = "Verification_Query_For_Gold_DLT_Table"
#   data_source_id = "4cf184731231d984" #var.warehouse_data_source_id
# }

# resource "databricks_sql_query" "daily_summary_943ce445_af87_4797_9691_afde95c08e97" {

#   parent         = "folders/iot_dashboards/queries"
#   query          = "select \n\t`date`\n\t,sum(power) as power_generated\n\t,count(distinct case when maintenance = 1 then deviceId else null end) AS broken_turbines \nfrom \n\thive_metastore.dlt_demo.gold_turbine_data\nwhere\n\t`date` <= getdate()\ngroup by\n\t`date`\norder by\n\t`date` desc"
#   name           = "Daily_Summary"
#   data_source_id = var.warehouse_data_source_id
# }

# resource "databricks_sql_query" "gold_table_data_0452cdab_e378_4a2a_a1e2_86fa8b6f9c73" {
#   parent         = "folders/iot_dashboards/queries"
#   query          = "select\n  *\nfrom\n  hive_metastore.dlt_demo.gold_turbine_data\nwhere\n  `date` <= getdate()"
#   name           = "Gold_table_data"
#   data_source_id = var.warehouse_data_source_id
# }

# resource "databricks_sql_query" "gold_table_query_check_746e141c_1040_4d94_b069_e7f52fa21492" {
#   parent         = "folders/iot_dashboards/queries"
#   query          = "SELECT\n  sensor.*,\n  weather.temperature,\n  weather.humidity,\n  weather.windspeed,\n  weather.winddirection,\n  maint.maintenance,\n  power.power\nFROM\n  hive_metastore.dlt_demo.silver_agg_turbine_data sensor\n  INNER JOIN hive_metastore.dlt_demo.silver_agg_weather_data weather ON sensor.`date` = weather.`date`\n  AND sensor.`window` = weather.`window`\n  INNER JOIN hive_metastore.dlt_demo.silver_maintenance_data maint ON sensor.`date` = maint.`date`\n  and sensor.devicedata_source_id = maint.deviceid\n  INNER JOIN hive_metastore.dlt_demo.silver_poweroutput_data power ON sensor.`date` = power.`date`\n  AND sensor.`window` = power.`window`\n  AND sensor.devicedata_source_id = power.deviceid"
#   name           = "Gold_table_query_check"
#   data_source_id = var.warehouse_data_source_id
# }

# resource "databricks_sql_query" "maintenance_status_35d30e19_a826_430e_982e_23bb07c8c855" {
#   parent         = "folders/iot_dashboards/queries"
#   query          = "select \n\t`date`\n\t,case \n\t\twhen maintenance = 1 then deviceId else null \n\t\tend as maintenance_turbine\nfrom \n\thive_metastore.dlt_demo.silver_maintenance_data\nwhere\n\t`date` <= getdate()"
#   name           = "Maintenance_Status"
#   data_source_id = var.warehouse_data_source_id
# }

# resource "databricks_sql_query" "power_production_and_loss_2aceefeb_23ab_4e72_acd5_4c494039df6e" {
#   parent         = "folders/iot_dashboards/queries"
#   query          = "select \n\tpw.`date`\n\t,pw.deviceId\n\t,sum(case when md.maintenance = 0 then `power` else 0 end) \t\t\t\t\t\t\t\t\tas daily_actual_power\n\t,sum(`power`) \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tas daily_theoretical_power\n\t,sum(`power`) - sum(case when md.maintenance = 0 then `power` else 0 end)\t\tas daily_defict\nfrom \n\thive_metastore.dlt_demo.silver_poweroutput_data as pw\n\tjoin hive_metastore.dlt_demo.silver_maintenance_data md on pw.devicedata_source_id = md.deviceId and pw.`date` = md.`date` \nwhere\n\tpw.deviceId <> \"WindTurbine-10\"\n\tand pw.`date` <= getdate()\ngroup by\n\tpw.`date`\n\t,pw.deviceId\norder by\n\tpw.`date`\n\t,pw.deviceId"
#   name           = "Power_production_and_loss"
#   data_source_id = var.warehouse_data_source_id
# }

# resource "databricks_sql_query" "summary_power_production_and_loss_58236411_2f20_4cc5_ad8d_e415fb02466e" {

#   parent         = "folders/iot_dashboards/queries"
#   query          = "select \n\tsum(case when md.maintenance = 0 then `power` else 0 end) \t\t\t\t\t\t\t\t\tas daily_actual_power\n\t,sum(`power`) \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tas daily_theoretical_power\n\t,sum(`power`) - sum(case when md.maintenance = 0 then `power` else 0 end)\t\tas daily_defict\nfrom \n\thive_metastore.dlt_demo.silver_poweroutput_data as pw\n\tjoin hive_metastore.dlt_demo.silver_maintenance_data md on pw.devicedata_source_id = md.deviceId and pw.`date` = md.`date` \nwhere\n\tpw.deviceId <> \"WindTurbine-10\"\n"
#   name           = "Summary_power_production_and_loss"
#   data_source_id = var.warehouse_data_source_id
# }

# resource "databricks_sql_query" "turbine_rotation_data_d43ca92d_2a51_4019_972a_1104855f02a4" {
#   parent         = "folders/iot_dashboards/queries"
#   query          = "select\n  *\nfrom\n  hive_metastore.dlt_demo.silver_agg_turbine_data\nwhere\n  `window` >= getdate() - INTERVAL 7 DAYS\n  and `date` <= getdate()"
#   name           = "Turbine_rotation_data"
#   data_source_id = var.warehouse_data_source_id
# }

# resource "databricks_sql_query" "weather_data_8777f989_6390_4ec7_bd79_6ab21d18ad07" {
#   parent         = "folders/iot_dashboards/queries"
#   query          = "select\n  *\nfrom\n  hive_metastore.dlt_demo.silver_agg_weather_data\nwhere\n  `window` >= getdate() - INTERVAL 7 DAYS\n  and `date` <= getdate()"
#   name           = "Weather_data"
#   data_source_id = var.warehouse_data_source_id
# }


# // Queries for demo v2
# resource "databricks_sql_query" "gold_table_query_check_v2" {
#   parent         = "folders/iot_dashboards/queries"
#   query          = <<EOT
#                     SELECT
#                       sensor.*,
#                       weather.temperature, 
#                       weather.humidity, 
#                       weather.windspeed, 
#                       weather.winddirection,
#                       maint.maintenance,
#                       power.power
#                     FROM
#                       hive_metastore.dlt_demo_v2.silver_agg_turbine_data sensor
#                       INNER JOIN hive_metastore.dlt_demo_v2.silver_agg_weather_data weather
#                         ON sensor.`date` = weather.`date` AND sensor.`window` = weather.`window`
#                       INNER JOIN hive_metastore.dlt_demo_v2.silver_maintenance_data maint
#                         ON sensor.`date` = maint.`date` and sensor.devicedata_source_id = maint.deviceid
#                       INNER JOIN hive_metastore.dlt_demo_v2.silver_poweroutput_data power
#                       ON sensor.`date` = power.`date` AND sensor.`window` = power.`window` AND sensor.devicedata_source_id = power.deviceid 
#                 EOT
#   name           = "Verification_Query_For_Gold_DLT_Table_v2"
#   data_source_id = var.warehouse_data_source_id
# }


# resource "databricks_sql_query" "daily_summary_v2" {
#   parent         = "folders/iot_dashboards/queries"
#   query          = "select \n\t`date`\n\t,sum(power) as power_generated\n\t,count(distinct case when maintenance = 1 then deviceId else null end) AS broken_turbines \nfrom \n\thive_metastore.dlt_demo_v2.gold_turbine_data\nwhere\n\t`date` <= getdate()\ngroup by\n\t`date`\norder by\n\t`date` desc"
#   name           = "Daily_Summary_v2"
#   data_source_id = var.warehouse_data_source_id
# }

# resource "databricks_sql_query" "gold_table_data_v2" {
#   parent         = "folders/iot_dashboards/queries"
#   query          = "select\n  *\nfrom\n  hive_metastore.dlt_demo_v2.gold_turbine_data\nwhere\n  `date` <= getdate()"
#   name           = "Gold_table_data_v2"
#   data_source_id = var.warehouse_data_source_id
# }

# resource "databricks_sql_query" "maintenance_status_v2" {
#   parent         = "folders/iot_dashboards/queries"
#   query          = "select \n\t`date`\n\t,case \n\t\twhen maintenance = 1 then deviceId else null \n\t\tend as maintenance_turbine\nfrom \n\thive_metastore.dlt_demo_v2.silver_maintenance_data\nwhere\n\t`date` <= getdate()"
#   name           = "Maintenance_Status_v2"
#   data_source_id = var.warehouse_data_source_id
# }

# resource "databricks_sql_query" "power_production_and_loss_v2" {
#   parent         = "folders/iot_dashboards/queries"
#   query          = "select \n\tpw.`date`\n\t,pw.deviceId\n\t,sum(case when md.maintenance = 0 then `power` else 0 end) \t\t\t\t\t\t\t\t\tas daily_actual_power\n\t,sum(`power`) \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tas daily_theoretical_power\n\t,sum(`power`) - sum(case when md.maintenance = 0 then `power` else 0 end)\t\tas daily_defict\nfrom \n\thive_metastore.dlt_demo_v2.silver_poweroutput_data as pw\n\tjoin hive_metastore.dlt_demo_v2.silver_maintenance_data md on pw.devicedata_source_id = md.deviceId and pw.`date` = md.`date` \nwhere\n\tpw.deviceId <> \"WindTurbine-10\"\n\tand pw.`date` <= getdate()\ngroup by\n\tpw.`date`\n\t,pw.deviceId\norder by\n\tpw.`date`\n\t,pw.deviceId"
#   name           = "Power_production_and_loss_v2"
#   data_source_id = var.warehouse_data_source_id
# }

# resource "databricks_sql_query" "summary_power_production_and_loss_v2" {
#   parent         = "folders/iot_dashboards/queries"
#   query          = "select \n\tsum(case when md.maintenance = 0 then `power` else 0 end) \t\t\t\t\t\t\t\t\tas daily_actual_power\n\t,sum(`power`) \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tas daily_theoretical_power\n\t,sum(`power`) - sum(case when md.maintenance = 0 then `power` else 0 end)\t\tas daily_defict\nfrom \n\thive_metastore.dlt_demo_v2.silver_poweroutput_data as pw\n\tjoin hive_metastore.dlt_demo_v2.silver_maintenance_data md on pw.devicedata_source_id = md.deviceId and pw.`date` = md.`date` \nwhere\n\tpw.deviceId <> \"WindTurbine-10\"\n"
#   name           = "Summary_power_production_and_loss_v2"
#   data_source_id = var.warehouse_data_source_id
# }

# resource "databricks_sql_query" "turbine_rotation_data_v2" {
#   parent         = "folders/iot_dashboards/queries"
#   query          = "select\n  *\nfrom\n  hive_metastore.dlt_demo_v2.silver_agg_turbine_data\nwhere\n  `window` >= getdate() - INTERVAL 7 DAYS\n  and `date` <= getdate()"
#   name           = "Turbine_rotation_data_v2"
#   data_source_id = var.warehouse_data_source_id
# }

# resource "databricks_sql_query" "weather_data_v2" {
#   parent         = "folders/iot_dashboards/queries"
#   query          = "select\n  *\nfrom\n  hive_metastore.dlt_demo_v2.silver_agg_weather_data\nwhere\n  `window` >= getdate() - INTERVAL 7 DAYS\n  and `date` <= getdate()"
#   name           = "Weather_data_v2"
#   data_source_id = var.warehouse_data_source_id
# }
