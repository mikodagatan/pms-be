require 'rails_helper'

RSpec.describe CardHistories::CreateTaskService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }
  let!(:task) { create(:task, card:) }

  describe '#call' do
    let(:service) { CardHistories::CreateTaskService.new(user, task) }

    it 'creates a card history' do
      expect(service.call).to eq(true)
      expect { service.call }.to change(CardHistory, :count).by(1)
    end

    it 'returns an output' do
      service.call
      expect(CardHistory.last.output).to eq("<strong>#{user.full_name}</strong> has created the developer task: <strong>#{task.name}</strong>")
    end

    context 'when user testing task' do
      let!(:task) { create(:task, card:, type: 'UserTestingTask') }

      it 'returns an output' do
        service.call

        expect(CardHistory.last.output).to eq("<strong>#{user.full_name}</strong> has created the user testing task: <strong>#{task.name}</strong>")
      end
    end

    context 'when with ai' do
      let(:service) { CardHistories::CreateTaskService.new(user, task, use_ai: true) }

      it 'returns an output' do
        service.call

        expect(CardHistory.last.output).to eq("<strong>#{user.full_name}</strong> has created the developer task with AI: <strong>#{task.name}</strong>")
      end
    end
  end
end
