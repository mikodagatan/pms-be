class ConfirmationsController < ApplicationController
  skip_before_action :authenticate_user

  def confirm_email
    service = Users::ConfirmationService.new(confirm_params)

    if service.call
      redirect_to "#{ENV['FRONT_END_URL']}/login?email_confirmed=true", allow_other_host: true
    else
      redirect_to "#{ENV['FRONT_END_URL']}/login?token_changed=true", allow_other_host: true
    end
  end

  private

  def confirm_params
    params.permit(:token)
  end
end
