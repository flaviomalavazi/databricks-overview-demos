#!/bin/bash

set -e

eval "$(jq -r '@sh "IAM_ROLE_NAME=\(.role_name) AWS_PROFILE=\(.aws_profile)"')"

RESULT=`aws --profile $AWS_PROFILE iam get-role --role-name $IAM_ROLE_NAME --output json | jq -r '.Role.RoleName' ` || RESULT="false"

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n --arg result "$RESULT" '{"message":$result}'
