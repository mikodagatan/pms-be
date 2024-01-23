require 'rails_helper'

RSpec.describe Api::V1::ImageUploadsController, type: :request do
  let!(:user) { create(:user) }

  describe '#create' do
    context 'when uploading files' do
      before do
        allow_any_instance_of(S3::UploadImageService).to receive(:call).and_return('sample.url')
      end

      it 'returns true' do
        post '/api/v1/image_upload', params: { image: 'image' }, headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to eq({ url: 'sample.url' })
      end
    end
  end

  describe '#destroy' do
    context 'when destroying files' do
      before do
        allow_any_instance_of(S3::DeleteImageService).to receive(:call).and_return('sample.url')
      end

      it 'returns true' do
        post '/api/v1/image_delete', params: { url: 'sample.url' }, headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to eq({ success: true })
      end
    end
  end
end
