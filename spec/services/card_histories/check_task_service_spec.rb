require 'rails_helper'

RSpec.describe CardHistories::CheckTaskService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }
  let!(:task) { create(:task, card_id: card.id, checked: false) }

  describe '#call' do
    let(:service) { CardHistories::CheckTaskService.new(user, task) }

    before do
      task.assign_attributes(checked: true)
    end

    context 'when task present' do
      it 'creates a card history' do
        expect { service.call }.to change(CardHistory, :count).by(1)
      end

      context 'when checked' do
        it 'outputs a message' do
          service.call

          expect(CardHistory.last.output).to eq("<strong>#{user.full_name}</strong> has marked the developer task as done: <strong>#{task.name}</strong>")
        end

        it 'has status improved' do
          service.call

          expect(CardHistory.last.action_status).to eq('improved')
        end
      end

      context 'when unchecked' do
        before do
          task.assign_attributes(checked: false)
        end

        it 'outputs a message' do
          service.call

          expect(CardHistory.last.output).to eq("<strong>#{user.full_name}</strong> has marked the developer task as unfinished: <strong>#{task.name}</strong>")
        end

        it 'has status normal' do
          service.call

          expect(CardHistory.last.action_status).to eq('normal')
        end
      end
    end
  end
end
