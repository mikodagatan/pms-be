module S3
  class DeleteImageService
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def call
      delete_s3_object
    end

    private

    def object_key_from_url
      CGI.unescape(URI.parse(url).path[1..])
    end

    def delete_s3_object
      S3_BUCKET.object(object_key_from_url)&.delete
    end
  end
end
