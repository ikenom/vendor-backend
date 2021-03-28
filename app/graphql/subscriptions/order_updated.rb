module Subscriptions
  class OrderUpdated < BaseSubscription
    field :id, ID, null: false
  end
end