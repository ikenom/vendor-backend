class Types::SubscriptionType < GraphQL::Schema::Object
  field :order_updated, subscription: Subscriptions::OrderUpdated
end