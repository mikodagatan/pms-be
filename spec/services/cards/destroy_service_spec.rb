require 'rails_helper'

RSpec.describe Cards::UpdateService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }

  describe '#call' do
    let(:service) { Cards::DestroyService.new(user, card) }

    context 'when card is present' do
      it 'destroys the card' do
        expect(service.call).to be_truthy
        expect(Card.all).not_to include(card)
      end

      it 'broadcasts that the card is destroyed' do
        expect do
          service.call
        end.to have_broadcasted_to("project_channel_#{card.project.id}").from_channel(ProjectChannel)
      end
    end

    context 'when card is not present' do
      let(:card) { nil }
      it 'returns an error' do
        expect(service.call).to be_falsey
        expect(service.errors).to include({ error: "undefined method `destroy' for nil:NilClass" })
      end
    end
  end
end
