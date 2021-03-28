class User
  include Mongoid::Document

  field :user_id, type: String
  has_many :orders
  has_many :sessions
end