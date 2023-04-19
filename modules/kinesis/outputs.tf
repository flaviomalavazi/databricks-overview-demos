output "kinesis_stream_arn" {
  value = resource.aws_kinesis_stream.this.arn
  description = "ARN for the kinesis stream"
}

output "kinesis_stream_name" {
  value = resource.aws_kinesis_stream.this.name
  description = "Name of the kinesis stream"
}

output "kinesis_stream_id" {
  value = resource.aws_kinesis_stream.this.id
  description = "ID of the kinesis stream"
}
