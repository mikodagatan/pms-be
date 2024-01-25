require 'rails_helper'

RSpec.describe S3::DeleteImagesFromHtmlService do
  describe '#call' do
    let(:text) { "<img src='sample-src' />" }
    let(:service) { described_class.new(text) }
    before do
      allow_any_instance_of(Aws::S3::Bucket).to receive_message_chain(:object, :delete).and_return(true)
    end

    it 'deletes s3 object from url' do
      expect_any_instance_of(S3::DeleteImageService).to receive(:call).once
      expect(service.call).to eq(['sample-src'])
    end
  end
end
