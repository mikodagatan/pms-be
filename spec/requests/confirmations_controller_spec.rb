require 'rails_helper'

RSpec.describe ConfirmationsController, type: :request do
  before do
    stub_const('ENV', ENV.to_hash.merge('FRONT_END_URL' => 'localhost:8000'))
  end

  describe '#confirm_email' do
    context 'when email confirmed' do
      let!(:user) { create(:user, confirmed_at: nil, confirmation_token: '1') }

      it 'confirms the email and redirects the user to the FE' do
        get '/auth/confirm_email', params: { token: '1' }

        user.reload
        expect(user.confirmed?).to eq(true)
        expect(response).to redirect_to('localhost:8000/login?email_confirmed=true')
      end
    end

    context 'when token is changed' do
      let!(:user) { create(:user, confirmed_at: nil, confirmation_token: '2') }

      it 'redirects the user to the FE' do
        get '/auth/confirm_email', params: { token: '1' }

        user.reload
        expect(user.confirmed?).to eq(false)
        expect(response).to redirect_to('localhost:8000/login?token_changed=true')
      end
    end
  end
end
