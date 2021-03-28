class Session
  include Mongoid::Document

  field :jwt_token, type: String
  belongs_to :user

  def needs_actions
    after = nil
    has_next_page = true
    orders = []

    while has_next_page do
      data = core_service.orders(:KITCHEN, :SUBMITTED, after: after)
      data.edges.each do |edge|
        orders << Order.build_from_core(edge.node)
      end

      has_next_page = data.page_info.has_next_page
      after = data.page_info.end_cursor
    end

    orders
  end

  private

  def core_service
    CoreService.new(jwt_token: jwt_token)
  end
end