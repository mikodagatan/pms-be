class UserMailer < ApplicationMailer
  def send_password_reset(user)
    @user = user
    @token = user.reset_password_token
    mail(to: user.email, subject: 'PMS - Reset your password')
  end
end
