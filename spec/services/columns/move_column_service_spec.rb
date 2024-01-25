require 'rails_helper'

RSpec.describe Columns::MoveColumnService do
  let!(:user) { create(:user) }
  let!(:column) { create(:column) }

  describe '#call' do
    let(:service) { Columns::MoveColumnService.new(params) }
    let(:other_columns) { create_list(:column, 4, project: column.project) }
    let(:params) { { column_id: column.id, destination_index: 4 } }

    it 'moves the column' do
      service.call
      column.reload
      expect(column.position).to eq(5)
    end
  end
end
