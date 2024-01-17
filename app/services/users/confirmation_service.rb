module Users
  class ConfirmationService
    attr_reader :params, :token

    def initialize(params)
      @params = params
      @token = params[:token]
    end

    def call
      return false unless user

      user.assign_attributes(confirmed_at: DateTime.current)

      user.save!
    end

    private

    def user
      @user ||= User.find_by(confirmation_token: token)
    end
  end
end
