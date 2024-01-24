require 'rails_helper'

RSpec.describe CardHistories::GenerateAiService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }

  describe '#call' do
    let(:service) { CardHistories::GenerateAiService.new(user, card) }

    it 'creates a card history' do
      expect(service.call).to eq(true)
      expect { service.call }.to change(CardHistory, :count).by(1)
    end

    it 'returns an output' do
      service.call
      expect(CardHistory.last.output).to eq("<strong>#{user.full_name}</strong> has generated tasks through AI")
    end
  end
end
