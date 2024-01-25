require 'rails_helper'

RSpec.describe Mentions::MentionAssigneesService do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:card) do
    create(:card, assignees: [user, user2])
  end

  describe '#call' do
    let(:service) { Mentions::MentionAssigneesService.new(user, card) }

    it 'returns creates a mention per non-current user assignee' do
      expect { service.call }.to change(Mention, :count).by(1)
    end

    it 'calls mention create service per non-current user assignee' do
      allow_any_instance_of(Mentions::CreateService).to receive(:call).once
      service.call
    end
  end
end
