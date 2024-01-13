module Users
  class ResetPasswordService
    attr_reader :params, :error

    def initialize(params)
      @params = params
    end

    def call
      return set_not_found_error unless user
      return set_expired_error if expired?

      user.password = params[:password]
      user.reset_password_sent_at = 2.hours.ago
      user.save!
    end

    private

    def user
      @user ||= User.find_by(reset_password_token: params[:token])
    end

    def set_not_found_error
      @error = 'Cannot find user'
      false
    end

    def set_expired_error
      @error = 'Reset password token has expired'
      false
    end

    def expired?
      DateTime.current > user.reset_password_sent_at + 1.hour
    end
  end
end
