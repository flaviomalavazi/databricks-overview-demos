resource "aws_kinesis_stream" "this" {
  name                      = "${var.prefix}-kinesis-stream"
  shard_count               = 1
  retention_period          = 24
  enforce_consumer_deletion = false

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = merge(var.tags, { Name = "${var.prefix}-databricks-kinesis-stream" })

}

resource "aws_kinesis_stream_consumer" "this" {
  name       = "${var.prefix}-kinesis-stream-consumer"
  stream_arn = resource.aws_kinesis_stream.this.arn
}
