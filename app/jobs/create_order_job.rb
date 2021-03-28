class CreateOrderJob < ApplicationJob
  queue_as :vendor_backend_create_order

  def perform(user_id, order_id, kitchen_fulfillment_id, pickup_fulfillment_id)
    user = User.find_by(user_id: user_id)
    Order.create!(
      user_id: user.id.to_s,
      order_id: order_id,
      kitchen_fulfillment_id: kitchen_fulfillment_id,
      pickup_fulfillment_id: pickup_fulfillment_id
    )
  end
end