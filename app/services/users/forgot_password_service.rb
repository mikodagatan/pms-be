module Users
  class ForgotPasswordService
    attr_reader :params, :email, :errors

    def initialize(params)
      @params = params
      @email = params[:email]
      @errors = { email: [] }
    end

    def call
      return add_email_not_found_error unless user

      ActiveRecord::Base.transaction do
        user.assign_attributes(
          reset_password_token: SecureRandom.hex(20),
          reset_password_sent_at: DateTime.current
        )

        user.save!
        UserMailer.send_password_reset(user).deliver_later
      end
    rescue StandardError => e
      @errors = { error: e }
      false
    end

    private

    def user
      @user ||= User.find_by(email:) || User.find_by(username: email)
    end

    def add_email_not_found_error
      @errors[:email] << 'not found'
      false
    end
  end
end
