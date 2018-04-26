module "create_billing_order_placed_queue_subscribed_to_topic" {
  source = "../modules/create_sqs_subscribed_to_sns_topic"
  sns_topic_name = "OrderPlaced"
  account_number = "123"
  queue_name = "BillingOrderPlacedQueue"
  region = "us-east-1"
}