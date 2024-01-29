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
        UserMailer.send_confirmation(user).deliver_later
      end
      true
    rescue StandardError => e
      @errors = { error: e.message }
      false
    end
  end
end
