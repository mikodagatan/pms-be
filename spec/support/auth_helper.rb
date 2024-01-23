module AuthHelper
  def auth_headers(user)
    token = Jwt.encode({ email: user.email })

    { Authorization: "Bearer #{token}" }
  end
end
