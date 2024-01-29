require 'rails_helper'

RSpec.describe Tasks::CreateService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }
  let(:service) { described_class.new(user, params) }

  describe '#call' do
    context 'when task is a valid Developer Task' do
      let(:params) { { card_id: card.id, name: 'New Task', type: 'DeveloperTask' } }

      it 'returns true' do
        expect(service.call).to eq(true)
      end

      it 'creates a history' do
        expect do
          service.call
        end.to change(CardHistory, :count).by(1)
      end

      it 'broadcasts the change' do
        expect do
          service.call
        end.to have_broadcasted_to("card_channel_#{card.id}").from_channel(CardChannel)
      end
    end
  end
end
