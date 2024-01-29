require 'rails_helper'

RSpec.describe Tasks::DestroyService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }
  let!(:task) { create(:task, card:) }
  let(:service) { described_class.new(user, task) }

  describe '#call' do
    context 'when task is present' do
      it 'returns true' do
        expect(service.call).to eq(true)
      end

      it 'deletes the task' do
        expect do
          service.call
        end.to change(Task, :count).by(-1)
      end

      it 'broadcasts the change' do
        expect do
          service.call
        end.to have_broadcasted_to("card_channel_#{card.id}").from_channel(CardChannel)
      end
    end

    context 'when task is not present' do
      let(:task) { nil }

      it 'returns false' do
        expect(service.call).to eq(false)
      end

      it 'returns errors' do
        service.call

        expect(service.errors[:error]).to eq("undefined method `card' for nil:NilClass")
      end
    end
  end
end
