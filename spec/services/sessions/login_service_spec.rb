require 'rails_helper'

RSpec.describe Sessions::LoginService do
  let(:service) { described_class.new(params) }
  let!(:user) { create(:user, email: 'user@email.com') }
  describe '#call' do
    context 'when able to login' do
      let(:params) { { email: 'user@email.com', password: 'password123' } }

      it 'returns true and token' do
        jwt_regex = /^eyJ[0-9a-zA-Z_-]+?\.[0-9a-zA-Z_-]+?(\.[0-9a-zA-Z_-]+)?$/

        expect(service.call).to eq(true)
        expect(service.token).to match(jwt_regex)
      end
    end

    context 'when email not found' do
      let(:params) { { email: 'user@notfound.com', password: 'password123' } }

      it 'returns an error' do
        service.call

        expect(service.errors[:email]).to eq(['is not found'])
      end
    end

    context 'when email is not confirmed' do
      let!(:user) { create(:user, email: 'user@email.com', confirmed_at: nil) }
      let(:params) { { email: 'user@email.com', password: 'password123' } }

      it 'returns an error' do
        service.call
        expect(service.errors[:email]).to eq(['is not yet confirmed. Sending confirmation email.'])
      end
    end

    context 'when password is incorrect' do
      let(:params) { { email: 'user@email.com', password: 'password' } }

      it 'returns an error' do
        service.call

        expect(service.errors[:password]).to eq(['is invalid'])
      end
    end
  end
end
