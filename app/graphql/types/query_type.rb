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

    field :in_kitchen, Types::OrderType.connection_type, null: false

    def in_kitchen
      session = Session.find_by(jwt_token: context[:jwt_token])
      session.in_kitchen
    end

    field :ready, Types::OrderType.connection_type, null: false

    def ready
      session = Session.find_by(jwt_token: context[:jwt_token])
      session.ready
    end

    field :history, Types::OrderType.connection_type, null: false

    def history
      session = Session.find_by(jwt_token: context[:jwt_token])
      session.history
    end
  end
end
