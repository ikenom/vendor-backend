module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Login
    field :send_to_kitchen, mutation: Mutations::SendToKitchen
  end
end
