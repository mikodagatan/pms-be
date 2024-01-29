require 'rails_helper'

RSpec.describe Users::SendConfirmationService do
  describe '#call' do
    let(:service) { described_class.new(user) }

    context 'when user is present' do
      let!(:user) { create(:user) }

      it 'returns true' do
        expect(service.call).to eq(true)
      end

      it 'sends changes confirmation_token' do
        service.call
        user.reload
        expect(user.confirmation_token).not_to eq(nil)
      end

      it 'sends an email' do
        expect(UserMailer).to receive(:send_confirmation).and_return(double(deliver_later: true)).once
        service.call
      end
    end

    context 'user is not found' do
      let!(:user) { nil }

      it 'returns false' do
        expect(service.call).to eq(false)
      end

      it 'returns an error' do
        service.call
        expect(service.errors).to eq({ error: "undefined method `assign_attributes' for nil:NilClass" })
      end
    end
  end
end
