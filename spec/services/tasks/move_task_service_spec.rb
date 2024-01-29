require 'rails_helper'

RSpec.describe Tasks::MoveTaskService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }
  let!(:task) { create(:task, card:) }
  let!(:other_tasks) { create_list(:task, 4, card:) }
  let(:service) { described_class.new(params) }

  describe '#call' do
    context 'when task is present' do
      let(:params) { { task_id: task.id, destination_index: 3 } }

      it 'returns true' do
        expect(service.call).to eq(true)
      end

      it 'broadcasts the change' do
        expect do
          service.call
        end.to have_broadcasted_to("card_channel_#{card.id}").from_channel(CardChannel)
      end
    end

    context 'when task is not present' do
      let(:params) { { task_id: nil, destination_index: 4 } }

      it 'returns false' do
        expect(service.call).to eq(false)
      end

      it 'returns errors' do
        service.call

        expect(service.errors[:error]).to eq("undefined method `insert_at' for nil:NilClass")
      end
    end
  end
end
