
resource "aws_sns_topic" "SnsTopicCodeBuild" {
  name = "SnsTopicCodeBuild"

}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.SnsTopicCodeBuild.arn
  protocol  = "email"
  endpoint  = var.NotificationEmail
}

resource "aws_sns_topic_policy" "SnsTopicPolicy" {

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "events.amazonaws.com"
      },
      Action = "sns:Publish",
      Resource = aws_sns_topic.SnsTopicCodeBuild.arn
    }]
  })

  arn = aws_sns_topic.SnsTopicCodeBuild.arn
}

#==================END SNS TOPIC===============================
