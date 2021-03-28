module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :needs_actions, Types::OrderType.connection_type, null: false

    def needs_actions
      session = Session.find_by(jwt_token: context[:jwt_token])
      session.needs_actions
    end
  end
end
