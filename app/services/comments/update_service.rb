module Comments
  class UpdateService
    attr_reader :current_user, :comment, :params, :errors

    def initialize(current_user, comment, params)
      @comment = comment
      @params = params
      @current_user = current_user
    end

    def call
      ActiveRecord::Base.transaction do
        comment.assign_attributes(params)
        mention_users if comment.content_changed?
        comment.save!
        broadcast
      end
      true
    rescue StandardError => e
      @errors = comment.errors.to_hash
      @errors[:error] = e
      false
    end

    private

    def broadcast
      ActionCable.server.broadcast(
        "card_channel_#{comment.resource.id}",
        { card: CardSerializer.render_as_hash(comment.resource) }
      )
    end

    def mention_users
      Mentions::MentionUserService.new(current_user, comment).call
    end
  end
end
