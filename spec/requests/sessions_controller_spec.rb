require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  before do
    stub_const('ENV', ENV.to_hash.merge('FRONT_END_URL' => 'localhost:8000'))
  end

  describe '#login' do
    context 'when user is found and password is correct' do
      let!(:user) { create(:user, email: 'sample@email.com') }

      it 'returns a token' do
        post '/auth/login', params: { email: 'sample@email.com', password: 'password123' }

        parsed_response = from_json(response.body)
        jwt_regex = /^eyJ[0-9a-zA-Z_-]+?\.[0-9a-zA-Z_-]+?(\.[0-9a-zA-Z_-]+)?$/

        expect(parsed_response).to include({ success: true })
        expect(parsed_response[:token]).to match(jwt_regex)
      end
    end

    context 'when user is not found' do
      it 'returns an error' do
        post '/auth/login', params: { email: 'sample@email.com', password: 'password123' }

        expect(from_json(response.body)).to eq({
                                                 success: false,
                                                 errors: { email: ['is not found'], password: [] }
                                               })
      end
    end

    context 'when password is incorrect' do
      let!(:user) { create(:user, email: 'sample@email.com', password: '123456', password_confirmation: '123456') }
      it 'returns an error' do
        post '/auth/login', params: { email: 'sample@email.com', password: 'password123' }

        expect(from_json(response.body)).to eq({
                                                 success: false,
                                                 errors: { email: [], password: ['is invalid'] }
                                               })
      end
    end
  end

  describe '#google_login' do
    it 'returns a redirect url' do
      get '/auth/google_login'

      expect(from_json(response.body)[:redirect_url]).to include('https://accounts.google.com/o/oauth2/auth?client_id=google-client-id&redirect_uri=http://localhost:3000/auth/callback&scope=https://www.googleapis.com/auth/userinfo.email%20profile&response_type=code')
    end
  end

  describe '#callback' do
    before do
      allow_any_instance_of(GoogleAuth).to receive(:handle_callback).and_return(google_auth_params)
      allow(Jwt).to receive(:encode).and_return('1')
    end

    it 'redirects the user' do
      get '/auth/callback'

      expect(response).to redirect_to('localhost:8000/auth/callback?token=1')
    end
  end
end
