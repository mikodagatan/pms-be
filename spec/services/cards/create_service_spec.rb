require 'rails_helper'

RSpec.describe Cards::CreateService do
  let!(:user) { create(:user) }
  describe '#call' do
    let(:service) { Cards::CreateService.new(user, params) }

    context 'when column is present' do
      let!(:column) { create(:column) }
      let(:params) { { column_id: column.id, name: 'New Card' } }

      it 'creates the card and returns true' do
        expect { service.call }.to change(Card, :count).by(1)
        expect(service.call).to eq(true)
      end

      it 'creates a card history' do
        expect { service.call }.to change(CardHistory, :count).by(1)
      end

      it 'broadcasts the change' do
        expect do
          service.call
        end.to have_broadcasted_to("project_channel_#{column.project.id}").from_channel(ProjectChannel)
      end
    end

    context 'when column is not present' do
      let(:params) { { name: 'New Card' } }

      it 'returns errors and false' do
        expect(service.call).to eq(false)
        expect(service.errors).to eq({ error: "Couldn't find Column without an ID" })
      end
    end
  end
end
