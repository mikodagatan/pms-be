module Api
  module V1
    class ImageUploadsController < ApplicationController
      def create
        service = S3::UploadImageService.new(params[:image])

        render json: { url: service.call }
      end

      def destroy
        S3::DeleteImageService.new(params[:url]).call

        render json: { success: true }
      end
    end
  end
end
