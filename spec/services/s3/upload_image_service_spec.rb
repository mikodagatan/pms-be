require 'rails_helper'

RSpec.describe S3::UploadImageService do
  describe '#call' do
    let(:image) { fixture_file_upload('image.jpg', 'image/jpeg') }

    it 'uploads the image to S3 and returns the public URL' do
      # Stub S3_BUCKET and S3_BUCKET.object to avoid actual S3 interactions
      s3_object_double = instance_double(Aws::S3::Object, upload_file: nil, public_url: 'https://example.com/image.jpg')
      allow(S3_BUCKET).to receive(:object).and_return(s3_object_double)

      service = described_class.new(image)
      result = service.call

      expect(result).to eq('https://example.com/image.jpg')
      expect(S3_BUCKET).to have_received(:object).with(%r{editor/\d+_image\.jpg})
      expect(s3_object_double).to have_received(:upload_file).with(image.tempfile)
    end
  end
end
