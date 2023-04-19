# // Queries
# // Dashboard Definition
# resource "databricks_sql_dashboard" "demo_dashboard_8b02222a_e374_4658_b766_8d7f379586ea" {
#   name = "[Demo] Wind Turbine Dashboard"
# }

# resource "databricks_sql_widget" "r094c6b3fe8c" {
#   visualization_id = resource.databricks_sql_visualization.nrt_rpm_turbines_d43ca92d_2a51_4019_972a_1104855f02a40118d43f_13d8_4df3_a773_e107774ef0c8.visualization_id
#   title            = "[NRT] - RPM Turbines"
#   position {
#     size_y = 8
#     size_x = 3
#     pos_y  = 24
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_8b02222a_e374_4658_b766_8d7f379586ea.id
# }

# resource "databricks_sql_widget" "r0c20409fa29" {
#   visualization_id = resource.databricks_sql_visualization.power_produced_per_day_2aceefeb_23ab_4e72_acd5_4c494039df6ed0fc87f3_950d_478a_b36f_414b83bea229.visualization_id
#   title            = "Power produced per day"
#   position {
#     size_y = 10
#     size_x = 6
#     pos_y  = 32
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_8b02222a_e374_4658_b766_8d7f379586ea.id
# }

# resource "databricks_sql_widget" "r105d406471b" {
#   visualization_id = resource.databricks_sql_visualization.agg_power_generated_kwh_0452cdab_e378_4a2a_a1e2_86fa8b6f9c734700f148_22c8_49cf_a16d_c4e5cace696a.visualization_id
#   title            = "[Agg] - Power Generated (KWh)"
#   position {
#     size_y = 11
#     size_x = 6
#     pos_y  = 5
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_8b02222a_e374_4658_b766_8d7f379586ea.id
# }

# resource "databricks_sql_widget" "r1a66606b344" {
#   visualization_id = resource.databricks_sql_visualization.summary_power_lost_due_to_maintenance_58236411_2f20_4cc5_ad8d_e415fb02466ea304d7f8_c661_48b0_a8b1_e7c88d5f0e7b.visualization_id
#   title            = "Power lost due to maintenance (All time)"
#   position {
#     size_y = 5
#     size_x = 2
#     pos_x  = 4
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_8b02222a_e374_4658_b766_8d7f379586ea.id
# }

# resource "databricks_sql_widget" "r4d3cff3be52" {
#   visualization_id = resource.databricks_sql_visualization.nrt_temperature_humidity_8777f989_6390_4ec7_bd79_6ab21d18ad07eed263ed_ad42_4256_976c_05848514af0b.visualization_id
#   title            = "[NRT] - Temperature & Humidity"
#   position {
#     size_y = 8
#     size_x = 3
#     pos_y  = 16
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_8b02222a_e374_4658_b766_8d7f379586ea.id
# }

# resource "databricks_sql_widget" "r5c7bfbc8665" {
#   visualization_id = resource.databricks_sql_visualization.turbines_under_maintenance_per_day_35d30e19_a826_430e_982e_23bb07c8c85523a1c77d_93e2_4ad2_8871_c29641dbafba.visualization_id
#   title            = "Turbines under maintenance per day"
#   position {
#     size_y = 8
#     size_x = 3
#     pos_y  = 42
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_8b02222a_e374_4658_b766_8d7f379586ea.id
# }

# resource "databricks_sql_widget" "r9c106de2c13" {
#   visualization_id = resource.databricks_sql_visualization.nrt_turbine_angle_d43ca92d_2a51_4019_972a_1104855f02a42423d6eb_4730_4fe2_b38d_b9fbe5ef4fac.visualization_id
#   title            = "[NRT] - Turbine Angle"
#   position {
#     size_y = 8
#     size_x = 3
#     pos_y  = 24
#     pos_x  = 3
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_8b02222a_e374_4658_b766_8d7f379586ea.id
# }

# resource "databricks_sql_widget" "rb3aa4145e34" {
#   visualization_id = resource.databricks_sql_visualization.nrt_wind_speed_direction_8777f989_6390_4ec7_bd79_6ab21d18ad07a6c92c56_5979_4851_9e9e_e0750028dd6e.visualization_id
#   title            = "[NRT] - Wind Speed & Direction"
#   position {
#     size_y = 8
#     size_x = 3
#     pos_y  = 16
#     pos_x  = 3
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_8b02222a_e374_4658_b766_8d7f379586ea.id
# }

# resource "databricks_sql_widget" "rd972e029932" {
#   visualization_id = resource.databricks_sql_visualization.power_loss_per_day_due_to_maintenance_2aceefeb_23ab_4e72_acd5_4c494039df6ef37034bc_1b31_4383_8f68_b32483f2221e.visualization_id
#   title            = "Daily power loss due to maintenance (KWh)"
#   position {
#     size_y = 8
#     size_x = 3
#     pos_y  = 42
#     pos_x  = 3
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_8b02222a_e374_4658_b766_8d7f379586ea.id
# }

# resource "databricks_sql_widget" "rf4c4dbceed1" {
#   visualization_id = resource.databricks_sql_visualization.power_generated_today_943ce445_af87_4797_9691_afde95c08e97b1c1c7a9_d26e_4f65_b69c_a8e3eb90dece.visualization_id
#   title            = "Power Generated Today"
#   position {
#     size_y = 5
#     size_x = 2
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_8b02222a_e374_4658_b766_8d7f379586ea.id
# }

# resource "databricks_sql_widget" "rf7da5910821" {
#   visualization_id = resource.databricks_sql_visualization.turbines_under_maintenance_today_943ce445_af87_4797_9691_afde95c08e97b9ac167c_9100_4594_8135_fb1e1b6ad2fc.visualization_id
#   title            = "Turbines under maintenance today"
#   position {
#     size_y = 5
#     size_x = 2
#     pos_x  = 2
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_8b02222a_e374_4658_b766_8d7f379586ea.id
# }

# // Dashboard Definition
# resource "databricks_sql_dashboard" "demo_dashboard_v2" {
#   name = "[Demo] Wind Turbine Dashboard v2"
# }

# resource "databricks_sql_widget" "r094c6b3fe8c_v2" {
#   visualization_id = resource.databricks_sql_visualization.nrt_rpm_turbines_v2.visualization_id
#   title            = "[NRT] - RPM Turbines"
#   position {
#     size_y = 8
#     size_x = 3
#     pos_y  = 24
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_v2.id
# }

# resource "databricks_sql_widget" "r0c20409fa29_v2" {
#   visualization_id = resource.databricks_sql_visualization.power_produced_per_day_v2.visualization_id
#   title            = "Power produced per day"
#   position {
#     size_y = 10
#     size_x = 6
#     pos_y  = 32
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_v2.id
# }

# resource "databricks_sql_widget" "r105d406471b_v2" {
#   visualization_id = resource.databricks_sql_visualization.agg_power_generated_kwh_v2.visualization_id
#   title            = "[Agg] - Power Generated (KWh)"
#   position {
#     size_y = 11
#     size_x = 6
#     pos_y  = 5
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_v2.id
# }
# resource "databricks_sql_widget" "r1a66606b344_v2" {
#   visualization_id = resource.databricks_sql_visualization.summary_power_lost_due_to_maintenance_v2.visualization_id
#   title            = "Power lost due to maintenance (All time)"
#   position {
#     size_y = 5
#     size_x = 2
#     pos_x  = 4
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_v2.id
# }

# resource "databricks_sql_widget" "r4d3cff3be52_v2" {
#   visualization_id = resource.databricks_sql_visualization.nrt_temperature_humidity_v2.visualization_id
#   title            = "[NRT] - Temperature & Humidity"
#   position {
#     size_y = 8
#     size_x = 3
#     pos_y  = 16
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_v2.id
# }

# resource "databricks_sql_widget" "r5c7bfbc8665_v2" {
#   visualization_id = resource.databricks_sql_visualization.turbines_under_maintenance_per_day_v2.visualization_id
#   title            = "Turbines under maintenance per day"
#   position {
#     size_y = 8
#     size_x = 3
#     pos_y  = 42
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_v2.id
# }

# resource "databricks_sql_widget" "r9c106de2c13_v2" {
#   visualization_id = resource.databricks_sql_visualization.nrt_turbine_angle_v2.visualization_id
#   title            = "[NRT] - Turbine Angle"
#   position {
#     size_y = 8
#     size_x = 3
#     pos_y  = 24
#     pos_x  = 3
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_v2.id
# }

# resource "databricks_sql_widget" "rb3aa4145e34_v2" {
#   visualization_id = resource.databricks_sql_visualization.nrt_wind_speed_direction_v2.visualization_id
#   title            = "[NRT] - Wind Speed & Direction"
#   position {
#     size_y = 8
#     size_x = 3
#     pos_y  = 16
#     pos_x  = 3
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_v2.id
# }

# resource "databricks_sql_widget" "rd972e029932_v2" {
#   visualization_id = resource.databricks_sql_visualization.power_loss_per_day_due_to_maintenance_v2.visualization_id
#   title            = "Daily power loss due to maintenance (KWh)"
#   position {
#     size_y = 8
#     size_x = 3
#     pos_y  = 42
#     pos_x  = 3
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_v2.id
# }

# resource "databricks_sql_widget" "rf4c4dbceed1_v2" {
#   visualization_id = resource.databricks_sql_visualization.power_generated_today_v2.visualization_id
#   title            = "Power Generated Today"
#   position {
#     size_y = 5
#     size_x = 2
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_v2.id
# }

# resource "databricks_sql_widget" "rf7da5910821_v2" {
#   visualization_id = resource.databricks_sql_visualization.turbines_under_maintenance_today_v2.visualization_id
#   title            = "Turbines under maintenance today"
#   position {
#     size_y = 5
#     size_x = 2
#     pos_x  = 2
#   }
#   dashboard_id = databricks_sql_dashboard.demo_dashboard_v2.id
# }
