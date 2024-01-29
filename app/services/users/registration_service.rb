module Users
  class RegistrationService
    attr_reader :params, :user, :errors

    def initialize(params)
      @params = params
    end

    def call
      @user = User.new(params)

      user.save!
      UserMailer.send_confirmation(user).deliver_later
      true
    rescue StandardError
      @errors = user.errors&.to_hash
      false
    end
  end
end
