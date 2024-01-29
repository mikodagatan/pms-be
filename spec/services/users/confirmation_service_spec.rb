require 'rails_helper'

RSpec.describe Users::ConfirmationService do
  let!(:user) { create(:user, confirmation_token: '1') }

  describe '#call' do
    let(:service) { described_class.new(params) }

    context 'when user is found through token' do
      let(:params) { { token: '1' } }

      it 'returns true' do
        expect(service.call).to eq(true)
      end

      it 'updates user confirmation' do
        service.call
        expect(user.confirmed?).to eq(true)
      end
    end

    context 'when user is not found' do
      let(:params) { { token: '2' } }

      it 'returns false' do
        expect(service.call).to eq(false)
      end
    end
  end
end
