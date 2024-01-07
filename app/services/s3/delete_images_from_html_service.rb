module S3
  class DeleteImagesFromHtmlService
    attr_reader :html_text

    def initialize(html_text)
      @html_text = html_text
    end

    def call
      doc = Nokogiri::HTML(html_text)
      urls = doc.css('img').map { |img| img['src'] }
      urls.each { |url| S3::DeleteImageService.new(url).call }
    end
  end
end
