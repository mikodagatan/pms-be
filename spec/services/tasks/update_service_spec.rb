require 'rails_helper'

RSpec.describe Tasks::UpdateService do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }
  let!(:task) { create(:task, card:) }
  let(:service) { described_class.new(user, task, params) }

  describe '#call' do
    context 'when task is present' do
      let(:params) { { name: 'new task', checked: true } }
      it 'returns true' do
        expect(service.call).to eq(true)
      end

      it 'creates history' do
        expect do
          service.call
        end.to change(CardHistory, :count).by(2)
      end

      it 'broadcasts the change' do
        expect do
          service.call
        end.to have_broadcasted_to("card_channel_#{card.id}").from_channel(CardChannel)
      end
    end

    context 'when task is not present' do
      let(:task) { nil }
      let(:params) { { name: 'new task' } }

      it 'returns false' do
        expect(service.call).to eq(false)
      end

      it 'returns errors' do
        service.call

        expect(service.errors[:error]).to eq("undefined method `assign_attributes' for nil:NilClass")
      end
    end
  end
end
