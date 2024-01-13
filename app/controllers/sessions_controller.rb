class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def login
    service = Sessions::LoginService.new(login_params)

    if service.call
      render json: { success: true, token: service.token }
    else
      render json: { success: false, errors: service.errors }, status: :unprocessable_entity
    end
  end

  def google_login
    render json: { redirect_url: google_auth.initiate_oauth2 }
  end

  def callback
    user_info = google_auth.handle_callback(params)
    user = Users::CreateFromGoogleAuthService.new(user_info).call
    token = Jwt.encode({ email: user.email, exp: 16.hours.from_now.to_i })

    redirect_to "#{ENV['FRONT_END_URL']}/auth/callback?token=#{token}", allow_other_host: true
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def google_auth
    @google_auth ||= GoogleAuth.new
  end

  def login_params
    params.permit(:email, :password, :remember_me)
  end
end
