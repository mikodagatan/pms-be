module Users
  class RegistrationService
    attr_reader :params, :user, :errors

    def initialize(params)
      @params = params
    end

    def call
      @user = User.new(params)

      user.save!
    rescue StandardError
      @errors = user.errors
      false
    end
  end
end
