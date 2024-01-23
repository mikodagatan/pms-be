class ResetPasswordController < ApplicationController
  skip_before_action :authenticate_user

  def create
    service = Users::ForgotPasswordService.new(create_params)

    if service.call
      render json: { success: true }
    else
      render json: { success: false, errors: service.errors }, status: :unprocessable_entity
    end
  end

  def reset_password
    service = Users::ResetPasswordService.new(reset_password_params)

    if service.call
      render json: { success: true }
    else
      render json: { success: false, errors: service.errors }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.permit(:email)
  end

  def reset_password_params
    params.permit(:token, :password)
  end
end
