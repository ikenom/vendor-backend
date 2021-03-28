# frozen_string_literal: true

class FulfillmentUpdatedConsumer
  include Hutch::Consumer
  consume "core.fulfillment.updated"
  queue_name "consumer_vendor_backend_fulfillment_updated"

  def process(message)
    order = Order.find_by(order_id: message[:order_id])
    order.update!(fulfillment_update_timestamp: Time.now)
  end
end
