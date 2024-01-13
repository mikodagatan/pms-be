class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user

  def register
    service = Users::RegistrationService.new(register_params)

    if service.call
      render json: { success: true }
    else
      render json: { success: false, errors: service.errors }, status: :unprocessable_entity
    end
  end

  private

  def register_params
    params.permit(:username, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end
