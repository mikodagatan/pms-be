module Users
  class SendConfirmationService
    attr_reader :user, :errors

    def initialize(user)
      @user = user
    end

    def call
      ActiveRecord::Base.transaction do
        user.assign_attributes(confirmation_token: SecureRandom.hex(20))

        user.save!
        UserMailer.send_confirmation(user).deliver_now
      end
    rescue StandardError => e
      @errors = { error: e }
      false
    end
  end
end
