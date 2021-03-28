class Session
  include Mongoid::Document

  field :jwt_token, type: String
  belongs_to :user

  def needs_actions
    orders(:KITCHEN, :SUBMITTED)
  end

  def in_kitchen
    orders(:KITCHEN, :ACCEPTED)
  end

  def ready
    orders(:PICKUP, :ACCEPTED)
  end

  def history
    orders(:PICKUP, :CLOSED)
  end

  private

  def orders(fulfilment_type, fulfillment_request_status)
    after = nil
    has_next_page = true
    orders = []

    while has_next_page do
      data = core_service.orders(fulfilment_type, fulfillment_request_status, after: after)
      data.edges.each do |edge|
        orders << Order.build_from_core(edge.node)
      end

      has_next_page = data.page_info.has_next_page
      after = data.page_info.end_cursor
    end

    orders
  end

  def core_service
    CoreService.new(jwt_token: jwt_token)
  end
end