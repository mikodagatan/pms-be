require 'rails_helper'

RSpec.describe ResetPasswordController, type: :request do
  describe '#create' do
    context 'when email is found' do
      let!(:user) { create(:user, email: 'found@email.com') }

      it 'creates a token and return true' do
        post '/auth/forgot_password', params: { email: 'found@email.com' }

        user.reload
        expect(user.reset_password_token).to be_truthy
        expect(from_json(response.body)).to eq({ success: true })
      end
    end

    context 'when email is not found' do
      it 'returns false and errors' do
        post '/auth/forgot_password', params: { email: 'notfound@email.com' }

        expect(from_json(response.body)).to eq({ success: false, errors: { email: ['not found'] } })
      end
    end
  end

  describe '#reset_password' do
    context 'when token is correct' do
      let!(:user) { create(:user, reset_password_token: '1', reset_password_sent_at: 5.minutes.ago) }

      it 'changes the password' do
        post '/auth/reset_password', params: { token: '1', password: 'newpassword' }

        user.reload
        expect(BCrypt::Password.new(user.password_digest) == 'newpassword').to eq(true)
        expect(from_json(response.body)).to eq({ success: true })
      end
    end

    context 'when token is incorrect' do
      let!(:user) { create(:user, reset_password_token: '2', reset_password_sent_at: 5.minutes.ago) }

      it 'returns an error' do
        post '/auth/reset_password', params: { token: '1', password: 'newpassword' }

        expect(from_json(response.body)).to eq({ success: false, errors: { error: 'Cannot find user' } })
      end
    end

    context 'when token is expired' do
      let!(:user) { create(:user, reset_password_token: '1', reset_password_sent_at: 70.minutes.ago) }

      it 'returns an error' do
        post '/auth/reset_password', params: { token: '1', password: 'newpassword' }

        expect(from_json(response.body)).to eq({ success: false,
                                                 errors: { error: 'Reset password token has expired' } })
      end
    end
  end
end
