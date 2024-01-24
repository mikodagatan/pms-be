require 'rails_helper'

RSpec.describe CardHistories::MoveCardService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }
  let!(:column1) { create(:column, name: 'column1') }
  let!(:column2) { create(:column, name: 'column2', project: column1.project, position: 2) }

  describe '#call' do
    let(:service) { CardHistories::MoveCardService.new(user, card, column1, column2) }

    it 'creates a card history' do
      expect(service.call).to eq(true)
      expect { service.call }.to change(CardHistory, :count).by(1)
    end

    it 'returns an output' do
      service.call
      expect(CardHistory.last.output).to eq("<strong>#{user.full_name}</strong> has moved the card from <strong>column1</strong> to <strong>column2</strong>")
    end

    context 'when move card from left to right' do
      let(:service) { CardHistories::MoveCardService.new(user, card, column1, column2) }

      it 'status improves' do
        service.call
        expect(CardHistory.last.action_status).to eq('improved')
      end
    end

    context 'when move card from right to left' do
      let(:service) { CardHistories::MoveCardService.new(user, card, column2, column1) }

      it 'status worsens' do
        service.call

        expect(CardHistory.last.action_status).to eq('worsened')
      end
    end
  end
end
