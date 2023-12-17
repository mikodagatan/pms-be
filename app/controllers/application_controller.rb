class ApplicationController < ActionController::API
  before_action :authenticate_user

  def authenticate_user
    token = request.headers['Authorization']
    return render_unauthorized unless token

    token = token.split(' ')&.last
    user_payload = Jwt.decode(token)
    return render_unauthorized unless user_payload

    @current_user = User.find_by(email: user_payload['email'])

    render json: { error: 'User not found' }, status: :unauthorized unless @current_user
  end

  private

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
