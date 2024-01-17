class UserMailer < ApplicationMailer
  def send_password_reset(user)
    @user = user
    @token = user.reset_password_token
    mail(to: user.email, subject: 'PMS - Reset your password')
  end

  def send_confirmation(user)
    @user = user
    @token = user.confirmation_token
    mail(to: user.email, subject: 'PMS - Confirm email address')
  end
end
