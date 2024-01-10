module Users
  class CreateFromGoogleAuthService
    attr_reader :google_auth_data, :user

    def initialize(google_auth_data)
      @google_auth_data = google_auth_data
    end

    def call
      @user = User.where(email:).first_or_initialize(user_params)
      user.save!

      user
    end

    private

    def email
      google_auth_data['emailAddresses']&.first&.dig('value')
    end

    def google_photo_url
      google_auth_data['photos']&.first&.dig('url')
    end

    def user_params
      names = google_auth_data['names']&.first

      {
        first_name: names&.dig('givenName'),
        last_name: names&.dig('familyName'),
        email:,
        google_photo_url:,
        username:
      }
    end

    def username
      names = google_auth_data['names']&.first

      string = ''
      string += names&.dig('givenName') if names&.dig('givenName')
      string += names&.dig('familyName') if names&.dig('familyName')
      string += email
      string
    end
  end
end
