# resource "aws_kinesis_stream" "demo_kinesis_stream" {
#   name                      = "${local.prefix}-kinesis-stream"
#   shard_count               = 1
#   retention_period          = 24
#   enforce_consumer_deletion = false

#   shard_level_metrics = [
#     "IncomingBytes",
#     "OutgoingBytes",
#   ]

#   stream_mode_details {
#     stream_mode = "PROVISIONED"
#   }

#   tags = merge(local.tags, { Name = "databricks-${local.prefix}-kinesis-stream" })

# }

# resource "aws_kinesis_stream_consumer" "demo_kinesis_stream_consumer" {
#   name       = "${local.prefix}-kinesis-stream-consumer"
#   stream_arn = aws_kinesis_stream.demo_kinesis_stream.arn
# }
