module Mentions
  class SendEmailService
    attr_reader :mention

    def initialize(mention)
      @mention = mention
    end

    def call
      ActiveRecord::Base.transaction do
        email = case mention.resource_type
                when 'Card'
                  MentionMailer.send_mention(mention)
                when 'Comment'
                  MentionMailer.send_mention(mention)
                when 'CardAssignee'
                  MentionMailer.send_assignment(mention)
                end

        email.deliver_now
        mention.update(email_sent_at: DateTime.current)
      end
    end
  end
end
