require 'rails_helper'

RSpec.describe CardHistories::UpdateDescriptionService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }

  describe '#call' do
    let(:service) { CardHistories::UpdateDescriptionService.new(user, card) }

    before do
      card.assign_attributes(description: 'New Description')
    end

    it 'creates a card history' do
      expect(service.call).to eq(true)
      expect { service.call }.to change(CardHistory, :count).by(1)
    end

    it 'returns an output' do
      service.call
      expect(CardHistory.last.output).to eq("<strong>#{user.full_name}</strong> changed the description")
    end

    it 'returns a diff using to field' do
      service.call
      expect(CardHistory.last.to).to eq("<div class='del'>#{card.description_was}</div><div class='ins'>New Description</div>")
    end
  end
end
