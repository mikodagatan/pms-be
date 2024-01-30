module Comments
  class DestroyService
    attr_reader :current_user, :comment

    def initialize(current_user, comment)
      @current_user = current_user
      @comment = comment
    end

    def call
      ActiveRecord::Base.transaction do
        comment.destroy
        comment.resource.reload
        broadcast
      end
      true
    end

    private

    def broadcast
      ActionCable.server.broadcast(
        "card_channel_#{comment.resource.id}",
        { card: CardSerializer.render_as_hash(comment.resource),
          sender_id: current_user.id }
      )
    end
  end
end
