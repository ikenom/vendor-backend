class Order
  include Mongoid::Document

  field :order_id, type: String
  belongs_to :user

  after_create :notify_subscribers

  class << self
    def build_from_core(core_order)
      line_items = core_order.line_items.nodes.map do |node|
        {
          id: node.product.id
        }
      end

      {
        id: core_order.id,
        created_at: core_order.created_at,
        price: core_order.total_price.amount,
        type: "TAKE OUT",
        customer: {
          first_name: core_order.user.first_name,
          last_name: core_order.user.last_name,
        },
        line_items: line_items
      }
    end
  end

  def notify_subscribers
    user.sessions.each do |session|
      VendorBackendSchema.subscriptions.trigger(:order_updated, {}, { id: self.to_global_id })
    end
  end
end