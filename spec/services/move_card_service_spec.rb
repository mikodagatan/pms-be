require 'rails_helper'

RSpec.describe Cards::MoveCardService do
  let(:project) { create(:project) }
  let(:source_column) { create(:column, project:) }
  let(:destination_column) { create(:column, project:) }
  let(:card) { create(:card, column: source_column) }

  let(:params) do
    {
      project_id: project.id,
      card_id: card.id,
      source_column_id: source_column.id,
      source_index: 0,
      destination_column_id: destination_column.id,
      destination_index: 1
    }
  end

  subject { described_class.new(params) }

  describe '#call' do
    context 'when moving the card to a different column' do
      it 'moves the card successfully' do
        expect { subject.call }.to change { card.reload.column }.to(destination_column)
      end
    end

    context 'when moving the card within the same column' do
      before { params[:destination_column_id] = source_column.id }

      it 'moves the card successfully' do
        expect { subject.call }.to_not(change { card.reload.column })
      end
    end

    context 'when an error occurs during the move' do
      before do
        card_double = instance_double(Card, remove_from_list: nil)
        allow(Card).to receive(:find).and_return(card_double)
        allow(card_double).to receive(:remove_from_list).and_raise(StandardError, 'Some error')
      end

      it 'returns false' do
        expect(subject.call).to be_falsey
      end
    end
  end
end
