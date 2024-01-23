require 'rails_helper'

RSpec.describe Api::V1::CardsController, type: :request do
  let!(:user) { create(:user) }

  describe '#show' do
    let!(:card) do
      create(:card,
             name: 'Card Name',
             description: 'Sample Description',
             estimate: 0.5,
             position: 1)
    end

    context 'card is found' do
      it 'returns the card' do
        get "/api/v1/cards/#{card.id}", headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: true })
        expect(parsed_response[:card]).to include(
          {
            name: 'Card Name',
            description: 'Sample Description',
            code: "#{card.project.code}-0001",
            position: 1,
            estimate: 0.5.to_s,
            assignee_ids: [],
            developer_tasks: [],
            comments: [],
            histories: [],
            column_id: card.column.id,
            requester_id: nil,
            id: card.id

          }
        )
      end
    end

    context 'card is not found' do
      it 'returns an error' do
        get '/api/v1/cards/1000', headers: auth_headers(user)

        parsed_response = from_json(response.body)

        expect(parsed_response).to include({ success: false })
      end
    end
  end

  describe '#create' do
    let!(:column) { create(:column) }
    let(:params) do
      {
        name: 'Sample Name',
        description: 'Sample Description',
        estimate: 0.5.to_s,
        column_id: column.id
      }
    end

    context 'card is valid' do
      it 'broadcasts project change, returns true and the card' do
        expect do
          post '/api/v1/cards', params:, headers: auth_headers(user)
        end.to have_broadcasted_to("project_channel_#{column.project.id}").from_channel(ProjectChannel)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: true })
        expect(parsed_response[:card]).to be_truthy
      end
    end

    context 'no column_id is supplied' do
      it 'returns error' do
        post '/api/v1/cards/', params: params.except(:column_id), headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ errors: { error: "Couldn't find Column without an ID" } })
      end
    end
  end

  describe '#update' do
    let!(:card) { create(:card) }
    let(:params) do
      {
        id: card.id,
        description: 'updated description'
      }
    end

    context 'card is valid' do
      it 'returns true and the card' do
        put '/api/v1/cards/update', params:, headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: true })
        expect(parsed_response[:card]).to be_truthy
      end
    end
  end

  describe '#move_card' do
    let!(:card) { create(:card) }
    let!(:other_cards) { create_list(:card, 2, column: card.column) }
    let!(:column2) { create(:column, project: card.project, position: 2) }

    context 'card is moved in same column' do
      let(:params) do
        { params: {
          project_id: card.project.id,
          card_id: card.id,
          source_column_id: card.column.id,
          destination_column_id: card.column.id,
          source_index: card.position - 1,
          destination_index: card.column.cards.count - 1
        } }
      end

      it 'broadcasts the change and return true' do
        expect do
          post '/api/v1/cards/move_card', params:, headers: auth_headers(user)
        end.to have_broadcasted_to("project_channel_#{card.project.id}").from_channel(ProjectChannel)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: true })
        expect(parsed_response[:card]).to be_truthy
      end
    end

    context 'card is moved to a different column' do
      let(:params) do
        { params: {
          project_id: card.project.id,
          card_id: card.id,
          source_column_id: card.column.id,
          destination_column_id: column2.id,
          source_index: card.position - 1,
          destination_index: card.column.cards.count - 1
        } }
      end

      it 'broadcasts the change and return true' do
        expect do
          post '/api/v1/cards/move_card', params:, headers: auth_headers(user)
        end.to have_broadcasted_to("project_channel_#{card.project.id}").from_channel(ProjectChannel)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: true })
        expect(parsed_response[:card]).to be_truthy
      end
    end

    context 'params key is not used' do
      let(:params) do
        {
          project_id: card.project.id,
          card_id: card.id,
          source_column_id: card.column.id,
          destination_column_id: column2.id,
          source_index: card.position - 1,
          destination_index: card.column.cards.count - 1
        }
      end

      it 'returns an error' do
        post '/api/v1/cards/move_card', params:, headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: false })
        expect(parsed_response).to include({ errors: { error: 'param is missing or the value is empty: params' } })
      end
    end
  end

  describe '#destroy' do
    context 'when card is found' do
      let!(:card) { create(:card) }

      it 'returns true' do
        delete "/api/v1/cards/#{card.id}", headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: true })
      end
    end

    context 'when card is not found' do
      it 'returns false' do
        delete '/api/v1/cards/1000', headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: false })
        expect(parsed_response).to include({ errors: { error: "undefined method `destroy' for nil:NilClass" } })
      end
    end
  end
end
