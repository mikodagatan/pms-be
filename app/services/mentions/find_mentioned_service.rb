module Mentions
  class FindMentionedService
    attr_reader :content

    def initialize(content)
      @content = content
    end

    def call
      extract_mentioned_users
    end

    private

    def extract_mentioned_users
      doc = Nokogiri::HTML.fragment(content)
      mentions = doc.css('.mention')

      mentioned_users = mentions.map do |mention|
        User.find_by(id: mention['data-id'])
      end

      mentioned_users.compact
    end
  end
end
