class MentionMailer < ApplicationMailer
  def send_mention(mention)
    @mention = mention
    @decorator = MentionDecorator.new(@mention).call
    subject = "PMS - Mentioned in #{@decorator.code}"
    mail(to: mention.mentioned.email, subject:)
  end

  def send_assignment(mention)
    @mention = mention
    @decorator = MentionDecorator.new(@mention).call
    subject = "PMS - Assigned to #{@decorator.code}"
    mail(to: mention.mentioned.email, subject:)
  end
end
