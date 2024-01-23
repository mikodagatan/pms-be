require 'rails_helper'

RSpec.describe RegistrationsController, type: :request do
  describe '#register' do
    let(:user_params) do
      {
        first_name: 'User',
        last_name: 'Player',
        username: 'userplayer',
        email: 'userplayer@email.com',
        password: 'password123',
        password_confirmation: 'password123'
      }
    end

    context 'when user registered' do
      it 'creates the user and returns success' do
        expect do
          post '/auth/register', params: user_params
        end.to change(User, :count).by(1)

        expect(from_json(response.body)).to eq({ success: true })
      end
    end

    context 'when username is taken' do
      let!(:user) { create(:user, username: 'username') }
      let(:incorrect_params) { user_params.merge(username: 'username') }

      it 'returns the errors' do
        expect do
          post '/auth/register', params: incorrect_params
        end.to change(User, :count).by(0)

        json_response = from_json(response.body)
        expect(json_response).to eq({ success: false, errors: { username: ['has already been taken'] } })
      end
    end
  end
end
