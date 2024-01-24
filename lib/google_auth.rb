require 'httparty'

class GoogleAuth
  include Rails.application.routes.url_helpers

  CLIENT_ID = Rails.env.test? ? 'google-client-id' : ENV['GOOGLE_CLIENT_ID']
  CLIENT_SECRET = ENV['GOOGLE_CLIENT_SECRET']
  REDIRECT_URI = Rails.application.routes.url_helpers.auth_callback_url

  attr_reader :state_manager

  def initialize
    @state_manager = StateManager.new
  end

  def initiate_oauth2
    state = generate_and_cache_state
    google_authorization_url(state)
  end

  def handle_callback(params)
    state = params[:state]

    raise StandardError, 'Invalid state parameter' unless @state_manager.valid_state?(state)

    @state_manager.clear_state(state)

    access_token = get_access_token(params[:code])
    get_google_user_info(access_token)
  end

  private

  def generate_and_cache_state
    state = SecureRandom.hex(16)
    @state_manager.cache_state(state)
    state
  end

  def get_access_token(code)
    response = ::HTTParty.post(
      'https://oauth2.googleapis.com/token',
      {
        body: {
          code:,
          client_id: CLIENT_ID,
          client_secret: CLIENT_SECRET,
          redirect_uri: REDIRECT_URI,
          grant_type: 'authorization_code'
        }
      }
    )

    JSON.parse(response.body)['access_token']
  end

  def get_google_user_info(access_token)
    user_info_response = HTTParty.get(
      'https://people.googleapis.com/v1/people/me?personFields=emailAddresses,names,photos',
      headers: { 'Authorization' => "Bearer #{access_token}" }
    )

    JSON.parse(user_info_response.body)
  end

  def google_authorization_url(state)
    scope = 'https://www.googleapis.com/auth/userinfo.email%20profile'

    'https://accounts.google.com/o/oauth2/auth?' \
    "client_id=#{CLIENT_ID}" \
    "&redirect_uri=#{REDIRECT_URI}" \
    "&scope=#{scope}" \
    '&response_type=code' \
    "&state=#{state}"
  end
end
