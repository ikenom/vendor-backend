require "graphql/client"
require "graphql/client/http"

module CoreServiceAPI
    release_name = ENV["RELEASE_NAME"].upcase
    release_name.gsub! "-", "_"

    HOST = ENV["#{release_name}_ECOMMERCE_STORE_FRONT_RAILS_SERVICE_HOST"]
    HTTP = GraphQL::Client::HTTP.new("http://#{HOST}/graphql") do
      def headers(context)
        token = context[:jwt_token]
        {
          "Authorization": "Bearer #{token}",
        }
      end
    end
    Schema = GraphQL::Client.load_schema(HTTP)
    Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
end


class CoreService
  attr_reader :jwt_token

  PAGE_LIMIT = 50

  def initialize(jwt_token: nil)
    @jwt_token = jwt_token
  end

  LoginQuery = CoreServiceAPI::Client.parse <<-'GRAPHQL'
    mutation($email: String!, $password: String!) {
      login(input: {email: $email, password: $password}) {
        token
        user {
          id
        }
      }
    }
  GRAPHQL

  def login(email, password)
    response = CoreServiceAPI::Client.query(LoginQuery, variables: {
      email: email,
      password: password,
    })
    response.data.login
  end

  GetOrderQuery = CoreServiceAPI::Client.parse <<-'GRAPHQL'
    query($first: Int!, $after: String, $fulfillmentType: FulfillmentType!, $fulfillmentRequestStatus: FulfillmentRequestStatus!) {
      orders(first: $first, after: $after, fulfillmentType: $fulfillmentType, fulfillmentRequestStatus: $fulfillmentRequestStatus) {
        pageInfo {
          endCursor
          hasNextPage
        }
        edges {
          node {
            id
            user {
              firstName
              lastName
            }
            canceledAt
            createdAt
            closedAt
            totalPrice {
              amount
            }
            lineItems {
              nodes {
                addons {
                  nodes {
                    name
                  }
                }
                pricedAddons {
                  nodes {
                    product {
                      name
                    }
                  }
                }
                product {
                  name
                  id
                }
              }
            }
          }
        }
      }
    }
  GRAPHQL

  def orders(type, request_status, first: PAGE_LIMIT, after: nil)
    response = CoreServiceAPI::Client.query(GetOrderQuery, variables: {
      first: first,
      after: after,
      fulfillmentType: type,
      fulfillmentRequestStatus: request_status
    }, context: { jwt_token: jwt_token })
    response.data.orders
  end
end