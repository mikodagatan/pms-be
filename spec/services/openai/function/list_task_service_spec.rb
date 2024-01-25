require 'rails_helper'

RSpec.describe Openai::Function::ListTasksService do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }

  describe '.call' do
    let(:developer_tasks) { open_ai_developer_tasks }
    let(:user_testing_tasks) { open_ai_user_testing_tasks }
    let(:card) { create(:card) }
    let!(:other_developer_tasks) { create_list(:task, 10, card:) }
    let!(:other_user_testing_tasks) { create_list(:task, 10, card:, type: 'UserTestingTask') }

    it 'removes current tasks and creates 2 developer tasks' do
      expect do
        described_class.call(current_user: user, card:, developer_tasks:, user_testing_tasks:)
      end.to change(DeveloperTask, :count).by(-8)
    end

    it 'removes current tasks creates 2 user testing tasks' do
      expect do
        described_class.call(current_user: user, card:, developer_tasks:, user_testing_tasks:)
      end.to change(UserTestingTask, :count).by(-8)
    end
  end

  describe '.params' do
    it 'shows params' do
      expect(described_class.params).to have_key(:name)
    end
  end
end
