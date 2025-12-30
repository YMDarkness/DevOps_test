# 람다 함수 정의
resource "aws_lambda_function" "ec2_scheduler" {
  filename = "lambda_function_payload.zip"
  function_name = "ec2_night_stop_scheduler"
  role = aws_iam_role.lambda_exec.arn
  handler = "scheduler.lambda_handler"
  runtime = "python3.10"
}

# 실행 규칙 1
resource "aws_cloudwatch_event_rule" "start_ec2" {
  name = "start-ec2-10am"
  schedule_expression = "cron(0 0 ? * MON-FRI *)" # UTC 00:00
}

# 실행 규칙 2
resource "aws_cloudwatch_event_rule" "stop_ec2" {
  name = "stop-ec2-11pm"
  schedule_expression = "cron(0 14 ? * MON-FRI *)" # UTC 14:00
}
