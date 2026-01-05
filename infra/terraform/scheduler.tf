# 람다 함수 정의
resource "aws_lambda_function" "ec2_scheduler" {
  filename = "lambda_function_payload.zip"
  function_name = "ec2_night_stop_scheduler"
  role = aws_iam_role.lambda_exec.arn
  handler = "scheduler.lambda_handler"
  runtime = "python3.10"

  timeout = 60
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
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

# 람다가 사용할 IAM 역할 생성
resource "aws_iam_role" "lambda_exec" {
  name = "ec2_scheduler_lambda_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# 람다에게 EC2 시작/중지 권한 부여 (policy)
resource "aws_iam_role_policy" "lambda_ec2_policy" {
  name = "lambda_ec2_scheduler_policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:DescribeInstances"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# EventBridge 규칙이 람다를 실행하도록 연결
resource "aws_cloudwatch_event_target" "start_ec2_target" {
  rule = aws_cloudwatch_event_rule.start_ec2.name
  target_id = "TriggerLambdaStart"
  arn = aws_lambda_function.ec2_scheduler.arn
  input = jsonencode({"action" : "start"})
}

resource "aws_cloudwatch_event_target" "stop_ec2_target" {
  rule = aws_cloudwatch_event_rule.stop_ec2.name
  target_id = "TriggerLambdaStop"
  arn = aws_lambda_function.ec2_scheduler.arn
  input = jsonencode({"action" : "stop"})
}

# EventBridge가 람다를 호출할 수 있도록 권한 부여
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id = "AllowExecutionFromEventBridge"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_scheduler.function_name
  principal = "events.amazonaws.com"
}
