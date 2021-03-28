module Mutations
  class ReadyFromKitchen < BaseMutation
    argument :order_id, ID, required: true
    field :succeeded, Boolean, null: false

    def resolve(order_id:)
      order = Order.find_by(order_id: order_id)
      core_service = CoreService.new(jwt_token: context[:jwt_token])
      core_service.complete_fulfillment(order.kitchen_fulfillment_id)
      core_service.start_fulfillment(order.pickup_fulfillment_id)
      {
        succeeded: true
      }
    end
  end
end