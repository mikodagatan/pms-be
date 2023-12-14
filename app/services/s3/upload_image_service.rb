module S3
  class UploadImageService
    attr_reader :image

    def initialize(image)
      @image = image
    end

    def call
      s3_object = S3_BUCKET.object("#{Time.now.to_i}_#{image.original_filename}")
      s3_object.upload_file(image.tempfile, acl: 'public-read')

      s3_object.public_url
    end
  end
end
