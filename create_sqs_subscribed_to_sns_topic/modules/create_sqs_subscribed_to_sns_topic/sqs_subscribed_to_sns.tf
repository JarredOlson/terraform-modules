variable "queue_name" {
}
variable "sns_topic_name" {
}
variable "region" {
  default = "us-east-1"
}
variable "account_number" {
}

data "aws_iam_policy_document" "sqs-policy" {
  statement {
    effect = "Allow"
    principals = {
      type = "AWS"
      identifiers = [
        "*"]
    }
    actions = [
      "sqs:SendMessage"]
    resources = [
      "${aws_sqs_queue.sqs-queue.arn}"
    ]
    condition {
      test = "ArnEquals"
      variable = "AWS:SourceArn"
      values = [
        "arn:aws:sns:${var.region}:${var.account_number}:${var.sns_topic_name}"]
    }
  }
}

resource "aws_sqs_queue" "sqs-queue" {
  name = "${var.queue_name}"
  message_retention_seconds = 1209600
}

resource "aws_sqs_queue_policy" "sqs-queue-policy" {
  queue_url = "${aws_sqs_queue.sqs-queue.id}"
  policy = "${data.aws_iam_policy_document.sqs-policy.json}"
}

resource "aws_sns_topic_subscription" "sqs_subscribed_to_sns" {
  topic_arn = "arn:aws:sns:${var.region}:${var.account_number}:${var.sns_topic_name}"
  protocol = "sqs"
  endpoint = "${aws_sqs_queue.sqs-queue.arn}"
}


output arn {
  value = "${aws_sqs_queue.sqs-queue.arn}"
}

output id {
  value = "${aws_sqs_queue.sqs-queue.id}"
}
