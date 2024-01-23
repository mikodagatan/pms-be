require 'rails_helper'

RSpec.describe Api::V1::ColumnsController, type: :request do
  let!(:user) { create(:user) }

  describe '#create' do
    context 'when column is valid' do
      let(:project) { create(:project) }
      let(:params) { { project_id: project.id } }

      it 'returns true and the column' do
        post '/api/v1/columns', params:, headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: true })
        expect(parsed_response[:column]).to include({
                                                      name: 'New Column'
                                                    })
      end
    end
  end

  describe '#update' do
    let!(:column) { create(:column) }
    context 'when params are valid' do
      let(:params) { { name: 'New Name', id: column.id } }

      it 'returns true' do
        put '/api/v1/columns/update', params:, headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: true })
      end
    end
  end

  describe '#move_column' do
    let!(:column) { create(:column) }
    let!(:column2) { create(:column, project: column.project) }

    context 'when params are valid' do
      let(:params) { { destination_index: 1, column_id: column.id } }

      it 'returns true' do
        post '/api/v1/columns/move_column', params:, headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: true })
      end
    end
  end

  describe '#destroy' do
    context 'when column is found' do
      let!(:column) { create(:column) }

      it 'returns true' do
        delete "/api/v1/columns/#{column.id}", headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: true })
      end
    end

    context 'when column is not found' do
      it 'returns false' do
        delete '/api/v1/columns/1000', headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: false })
      end
    end
  end
end
