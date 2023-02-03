/* 

################ Begin US East 2 Block ################

# hubcidr      = "10.178.0.0/20"
# spokecidr    = "10.179.0.0/20"
# no_public_ip = true
# rglocation   = "eastus2"
# metastore_hosts = ["consolidated-eastus2-prod-metastore.mysql.database.azure.com", "consolidated-eastus2-prod-metastore-addl-1.mysql.database.azure.com",
#   "consolidated-eastus2-prod-metastore-addl-2.mysql.database.azure.com", "consolidated-eastus2-prod-metastore-addl-3.mysql.database.azure.com",
#   "consolidated-eastus2c2-prod-metastore-0.mysql.database.azure.com", "consolidated-eastus2c2-prod-metastore-1.mysql.database.azure.com",
#   "consolidated-eastus2c2-prod-metastore-2.mysql.database.azure.com", "consolidated-eastus2c2-prod-metastore-3.mysql.database.azure.com",
#   "consolidated-eastus2c3-prod-metastore-0.mysql.database.azure.com"
# ]
# dbfs_prefix      = "dbfs"
# workspace_prefix = "adb"
# prefix           = "databricks-latam-demos"
# firewallfqdn = [ // we don't need scc relay and dbfs fqdn since they will go to private endpoint
#   "dbartifactsprodeastus2.blob.core.windows.net",
#   "arprodeastus2a1.blob.core.windows.net",
#   "arprodeastus2a2.blob.core.windows.net",
#   "arprodeastus2a3.blob.core.windows.net",
#   "arprodeastus2a4.blob.core.windows.net",
#   "arprodeastus2a5.blob.core.windows.net",
#   "arprodeastus2a6.blob.core.windows.net",
#   "arprodeastus2a7.blob.core.windows.net",
#   "arprodeastus2a8.blob.core.windows.net",
#   "arprodeastus2a9.blob.core.windows.net",
#   "arprodeastus2a10.blob.core.windows.net",
#   "arprodeastus2a11.blob.core.windows.net",
#   "arprodeastus2a12.blob.core.windows.net",
#   "arprodeastus2a13.blob.core.windows.net",
#   "arprodeastus2a14.blob.core.windows.net",
#   "arprodeastus2a15.blob.core.windows.net",      //databricks artifacts
#   "dbartifactsprodeastus.blob.core.windows.net", //databricks artifacts secondary
#   "dblogprodwestus.blob.core.windows.net",       //log blob
#   "dblogprodeastus2.blob.core.windows.net",
#   "prod-westus-observabilityEventHubs.servicebus.windows.net",
#   "prod-eastus2c2-observabilityeventhubs.servicebus.windows.net",
#   "prod-eastus2c3-observabilityeventhubs.servicebus.windows.net", //eventhub
#   "cdnjs.com",                                                    //ganglia
# ]

################ End of US East 2 Block ################
*/

hubcidr      = "10.178.0.0/20"
spokecidr    = "10.179.0.0/20"
no_public_ip = true
rglocation   = "brazilsouth"
# metastoreip      = "191.233.201.8"
dbfs_prefix      = "dbfs"
workspace_prefix = "adb"
metastore_hosts  = ["consolidated-brazilsouth-prod-metastore.mysql.database.azure.com"]
prefix           = "databricks-latam-demos"
firewallfqdn = [                                                    // we don't need scc relay and dbfs fqdn since they will go to private endpoint
  "dbartifactsprodbrazilsou.blob.core.windows.net",                 // databricks artifacts
  "dbartifactsprodsafrican.blob.core.windows.net",                  // databricks artifacts secondary
  "dblogprodbrazilsou.blob.core.windows.net",                       // log blob
  "prod-brazilsouth-observabilityeventhubs.servicebus.windows.net", // eventhub
  "cdnjs.com",                                                      // ganglia
]