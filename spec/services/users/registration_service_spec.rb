require 'rails_helper'

RSpec.describe Users::RegistrationService do
  describe '#call' do
    let(:service) { described_class.new(params) }

    context 'when user is valid' do
      let(:params) do
        { email: 'sample@email.com', first_name: 'Sample', last_name: 'User', username: 'sampleuser', password: 'password123',
          password_confirmation: 'password123' }
      end

      it 'returns true' do
        expect(service.call).to eq(true)
      end

      it 'sends an email' do
        expect(UserMailer).to receive(:send_confirmation).and_return(double(deliver_later: true)).once
        service.call
      end
    end

    context 'user is not valid, username is already taken' do
      let!(:user) { create(:user, username: 'sampleuser') }
      let(:params) do
        { email: 'sample@email.com', first_name: 'Sample', last_name: 'User', username: 'sampleuser', password: 'password123',
          password_confirmation: 'password123' }
      end

      it 'returns false' do
        expect(service.call).to eq(false)
      end

      it 'returns an error' do
        service.call
        expect(service.errors).to eq({ username: ['has already been taken'] })
      end
    end
  end
end
