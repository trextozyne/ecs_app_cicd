
resource "aws_cloudwatch_event_rule" "EventBridgeRule" {
  name = "CodeBuildEventRule"

  event_pattern = jsonencode({
    source = ["aws.codebuild"],
    detail_type = ["Codebuild Build Phase Change"],
    detail = {
      completed_phase = ["SUBMITTED", "PROVISIONING", "DOWNLOAD_SOURCE", "INSTALL", "PRE_BUILD", "BUILD", "POST_BUILD", "UPLOAD_ARTIFACTS", "FINALIZING"],
      completed_phase_status = ["TIMED_OUT", "STOPPED", "FAILED", "SUCCEEDED", "FAULT", "CLIENT_ERROR"],
      project_name = [var.codebuild_project_name]
    }
  })

  is_enabled     = true
  role_arn  = var.sns_notification_rule_iam_role
}

resource "aws_cloudwatch_event_target" "example" {
  arn  = var.codebuild_sns_topic_arn
  rule = aws_cloudwatch_event_rule.EventBridgeRule.name
  target_id = "CodeBuild_Project_SNS"

  input_transformer {
    input_paths = {
      "build-id"                = "$.detail.build-id"
      "project-name"            = "$.detail.project-name"
      "completed-phase"         = "$.detail.completed-phase"
      "completed-phase-status"  = "$.detail.completed-phase-status"
    }

    input_template = jsonencode("Build '<build-id>' for build project '<project-name>' has completed the build phase of '<completed-phase>' with a status of '<completed-phase-status>'.")
  }
}
#===========================END CLOUDWATCH================================================

