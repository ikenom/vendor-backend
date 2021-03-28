module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Login
    field :send_to_kitchen, mutation: Mutations::SendToKitchen
    field :ready_from_kitchen, mutation: Mutations::ReadyFromKitchen
    field :complete_order, mutation: Mutations::CompleteOrder
  end
end
