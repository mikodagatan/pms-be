require 'rails_helper'

RSpec.describe CardHistories::UpdateNameService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }

  describe '#call' do
    let(:service) { CardHistories::UpdateNameService.new(user, card) }

    before do
      card.assign_attributes(name: 'New Name')
    end
    it 'creates a card history' do
      expect(service.call).to eq(true)
      expect { service.call }.to change(CardHistory, :count).by(1)
    end

    it 'returns an output' do
      service.call
      expect(CardHistory.last.output).to eq("<strong>#{user.full_name}</strong> changed the name of the card from <strong>#{card.name_was}</strong> to <strong>#{card.name}</strong>")
    end
  end
end
