require 'rails_helper'

RSpec.describe Users::CreateFromGoogleAuthService do
  let(:google_auth_data) { google_auth_params }

  describe '#call' do
    let(:service) { described_class.new(google_auth_data) }

    context 'when user came from google auth' do
      it 'creates user' do
        expect do
          service.call
        end.to change(User, :count).by(1)
      end

      it 'returns the user' do
        expect(service.call).to eq(User.last)
      end

      it 'assigns attributes from google auth data' do
        user = service.call

        expect(user.first_name).to eq('Miguel')
        expect(user.last_name).to eq('Dagatan')
        expect(user.email).to eq('miguel.dagatan@gmail.com')
      end

      it 'assigns no password' do
        user = service.call

        expect(user.password_digest).to eq(nil)
      end
    end
  end
end
