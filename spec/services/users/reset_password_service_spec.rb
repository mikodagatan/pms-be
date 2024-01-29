require 'rails_helper'

RSpec.describe Users::ResetPasswordService do
  describe '#call' do
    let(:service) { described_class.new(params) }

    context 'when user is found and token not expired' do
      let!(:user) { create(:user, reset_password_token: '1', reset_password_sent_at: DateTime.current) }
      let(:params) do
        { password: 'newpassword', token: '1' }
      end

      it 'returns true' do
        expect(service.call).to eq(true)
      end

      it 'sends changes the password' do
        service.call
        user.reload
        expect(BCrypt::Password.new(user.password_digest) == 'newpassword').to eq(true)
      end
    end

    context 'user is not found' do
      let!(:user) { create(:user, reset_password_token: '1', reset_password_sent_at: DateTime.current) }
      let(:params) do
        { password: 'newpassword', token: '2' }
      end

      it 'returns false' do
        expect(service.call).to eq(false)
      end

      it 'returns an error' do
        service.call
        expect(service.errors).to eq({ error: 'Cannot find user' })
      end
    end

    context 'token is expired' do
      let!(:user) { create(:user, reset_password_token: '1', reset_password_sent_at: DateTime.current - 3.hours) }
      let(:params) do
        { password: 'newpassword', token: '1' }
      end

      it 'returns false' do
        expect(service.call).to eq(false)
      end

      it 'returns an error' do
        service.call
        expect(service.errors).to eq({ error: 'Reset password token has expired' })
      end
    end
  end
end
