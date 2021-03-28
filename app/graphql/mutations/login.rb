module Mutations
  class Login < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: false

    def resolve(**attributes)
      ecsf_service = CoreService.new
      login = ecsf_service.login(attributes[:email], attributes[:password])

      user = User.create!(user_id: login.user.id)
      Session.create!(user: user, jwt_token: login.token)

      {
        token: login.token
      }
    end
  end
end