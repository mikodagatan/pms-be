require 'rails_helper'

RSpec.describe Openai::CreateCardTaskService do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:card) { create(:card) }

  describe '#call' do
    let(:params) { { name: 'New Task' } }
    let(:service) { described_class.new(user, card, 'DeveloperTask', params) }

    context 'when developer task' do
      it 'creates a task' do
        expect { service.call }.to change(DeveloperTask, :count).by(1)
      end

      it 'returns the task id' do
        expect(service.call).to eq(Task.last.id)
      end
    end

    context 'when user testing task' do
      let(:service) { described_class.new(user, card, 'UserTestingTask', params) }

      it 'creates a task' do
        expect { service.call }.to change(UserTestingTask, :count).by(1)
      end

      it 'returns the task id' do
        expect(service.call).to eq(Task.last.id)
      end
    end

    context 'when task type is not within system' do
      let(:service) { described_class.new(user, card, 'SomeOtherTask', params) }
      it 'raises an error' do
        expect { service.call }.to raise_error(NoMethodError)
      end
    end
  end
end
