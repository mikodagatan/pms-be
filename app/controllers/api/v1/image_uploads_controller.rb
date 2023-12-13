module Api
  module V1
    class ImageUploadsController < ApplicationController
      def create
        uploaded_file = params[:image]

        # Use the AWS S3 uploader to move the file to S3
        s3_object = S3_BUCKET.object("#{Time.now.to_i}_#{uploaded_file.original_filename}")
        s3_object.upload_file(uploaded_file.tempfile, acl: 'public-read')

        # Return the S3 URL of the uploaded image
        render json: { url: s3_object.public_url }
      end
    end
  end
end
