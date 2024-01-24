require 'rails_helper'

RSpec.describe CardHistories::DeleteTaskService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }
  let!(:task) { create(:task, card:) }

  describe '#call' do
    let(:service) { CardHistories::DeleteTaskService.new(user, task) }

    it 'creates a card history' do
      expect(service.call).to eq(true)
      expect { service.call }.to change(CardHistory, :count).by(1)
    end

    it 'returns an output' do
      service.call
      expect(CardHistory.last.output).to eq("<strong>#{user.full_name}</strong> has deleted the developer task: <strong>#{task.name}</strong>")
    end
  end
end
