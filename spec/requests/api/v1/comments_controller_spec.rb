require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :request do
  let!(:user) { create(:user) }

  describe '#create' do
    context 'when comment is valid' do
      let!(:card) { create(:card) }
      let(:params) do
        {
          resource_id: card.id,
          resource_type: 'Card',
          content: 'Sample comment'
        }
      end

      it 'returns true and the comment' do
        expect do
          post '/api/v1/comments', params:, headers: auth_headers(user)
        end.to have_broadcasted_to("card_channel_#{card.id}").from_channel(CardChannel)

        parsed_response = from_json(response.body)

        expect(parsed_response).to include({ success: true })
        expect(parsed_response[:comment]).to include({ content: 'Sample comment' })
      end
    end

    context 'when comment has no resource' do
      let(:params) do
        {
          content: 'Sample comment'
        }
      end

      it 'returns false and the error' do
        post '/api/v1/comments', params:, headers: auth_headers(user)

        parsed_response = from_json(response.body)

        expect(parsed_response).to include({ success: false })
        expect(parsed_response).to include({ errors: {
                                             error: 'Validation failed: Resource must exist',
                                             resource: ['must exist']
                                           } })
      end
    end
  end

  describe '#update' do
    let!(:comment) { create(:comment) }

    context 'when comment is valid' do
      let(:params) { { id: comment.id, content: 'updated content' } }

      it 'returns true and the comment and broadcasts change' do
        expect do
          put '/api/v1/comments/update', params:, headers: auth_headers(user)
        end.to have_broadcasted_to("card_channel_#{comment.resource_id}").from_channel(CardChannel)

        parsed_response = from_json(response.body)

        expect(parsed_response).to include({ success: true })
        expect(parsed_response[:comment]).to include({ content: 'updated content' })
      end
    end
  end

  describe '#destroy' do
    let!(:comment) { create(:comment, commenter: user) }

    context 'when comment is found and commenter is current_user' do
      it 'returns true and broadcasts change' do
        expect do
          delete "/api/v1/comments/#{comment.id}", headers: auth_headers(user)
        end.to have_broadcasted_to("card_channel_#{comment.resource_id}").from_channel(CardChannel)

        parsed_response = from_json(response.body)

        expect(parsed_response).to include({ success: true })
      end
    end

    context 'when comment is found and commenter is not current_user' do
      let!(:comment) { create(:comment) }
      it 'returns false and error' do
        delete "/api/v1/comments/#{comment.id}", headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: false })
        expect(parsed_response).to include({ errors: { error: "Cannot delete other users' comments" } })
      end
    end
  end
end
