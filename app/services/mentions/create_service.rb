module Mentions
  class CreateService
    attr_reader :current_user, :resource, :mentioned

    def initialize(current_user, resource, mentioned)
      @current_user = current_user
      @resource = resource
      @mentioned = mentioned
    end

    def call
      mention = Mention.find_or_initialize_by(
        resource:,
        commenter: current_user,
        mentioned:
      )

      return unless mention.save
      return if mention.email_sent?

      Mentions::SendEmailService.new(mention).call
    end
  end
end
