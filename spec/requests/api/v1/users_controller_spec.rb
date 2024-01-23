require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let!(:user) { create(:user) }

  describe '#index' do
    let!(:user2) { create(:user) }

    it 'returns all the users of the app' do
      get '/api/v1/users', headers: auth_headers(user)

      parsed_response = from_json(response.body)
      expect(parsed_response).to include({ success: true })
      expect(parsed_response[:users].last).to include({ email: user2.email })
    end
  end

  describe '#me' do
    it 'returns all data of the user' do
      get '/api/v1/users/me', headers: auth_headers(user)

      parsed_response = from_json(response.body)
      expect(parsed_response).to include({ email: user.email })
    end
  end
end
