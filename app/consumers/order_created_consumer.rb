# frozen_string_literal: true

class OrderCreatedConsumer
  include Hutch::Consumer
  consume "core.order.created"
  queue_name "consumer_vendor_backed_order_created"

  def process(message)
    CreateOrderJob.perform_later(
      message[:user_id],
      message[:id],
      message[:kitchen_fulfillment_id],
      message[:pickup_fulfillment_id])
  end
end
