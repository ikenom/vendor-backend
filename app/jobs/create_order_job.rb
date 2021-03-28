class CreateOrderJob < ApplicationJob
  queue_as :vendor_backend_create_order

  def perform(user_id, order_id)
    user = User.find_by(user_id: user_id)
    Order.create!(user_id: user.id.to_s, order_id: order_id)
  end
end