require 'rails_helper'

RSpec.describe CardHistories::UpdateTaskNameService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }
  let!(:task) { create(:task, card:) }

  describe '#call' do
    let(:service) { CardHistories::UpdateTaskNameService.new(user, task) }

    before do
      task.assign_attributes(name: 'New Name')
    end

    it 'creates a card history' do
      expect(service.call).to eq(true)
      expect { service.call }.to change(CardHistory, :count).by(1)
    end

    it 'returns an output' do
      service.call
      expect(CardHistory.last.output).to eq("<strong>#{user.full_name}</strong> has updated the developer task from <strong>#{task.name_was}</strong> to <strong>#{task.name}</strong>")
    end
  end
end
