
output "codebuild_sns_topic_arn" {
  value = aws_sns_topic.SnsTopicCodeBuild.arn
}