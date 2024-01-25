module Comments
  class CreateService
    attr_reader :current_user, :params, :comment, :errors

    def initialize(current_user, params)
      @current_user = current_user
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        @comment = Comment.new(create_params)

        comment.save!
        mention_users
        broadcast
      end
      true
    rescue StandardError => e
      @errors = comment.errors&.to_hash || {}
      @errors[:error] = e.message
      false
    end

    private

    def create_params
      params.merge(commenter_id: current_user.id)
    end

    def broadcast
      ActionCable.server.broadcast(
        "card_channel_#{comment.resource.id}",
        { card: CardSerializer.render_as_hash(comment.resource) }
      )
    end

    def mention_users
      Mentions::MentionUsersService.new(current_user, comment).call
    end
  end
end
