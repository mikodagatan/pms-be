require 'rails_helper'

RSpec.describe S3::DeleteImageService do
  describe '#call' do
    let(:service) { described_class.new('sample-url') }
    before do
      allow_any_instance_of(Aws::S3::Bucket).to receive_message_chain(:object, :delete).and_return(true)
    end

    it 'deletes s3 object from url' do
      expect(service.call).to eq(true)
    end
  end
end
