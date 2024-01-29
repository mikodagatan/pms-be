require 'rails_helper'

RSpec.describe Users::ForgotPasswordService do
  let!(:user) { create(:user, email: 'sample@email.com') }

  describe '#call' do
    let(:service) { described_class.new(params) }

    context 'when user is found' do
      let(:params) { { email: 'sample@email.com' } }

      it 'returns true' do
        expect(service.call).to eq(true)
      end

      it 'updates user reset_password_token' do
        service.call
        user.reload
        expect(user.reset_password_token).not_to eq(nil)
        expect(user.reset_password_sent_at).not_to eq(nil)
      end

      it 'sends an email' do
        expect(UserMailer).to receive(:send_password_reset).and_return(double(deliver_later: true)).once
        service.call
      end
    end

    context 'when user is not found' do
      let(:params) { { email: 'notworking@email.com' } }

      it 'returns false' do
        expect(service.call).to eq(false)
      end

      it 'returns an error' do
        service.call
        expect(service.errors).to eq({ email: ['not found'] })
      end
    end
  end
end
