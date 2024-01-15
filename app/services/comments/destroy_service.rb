module Comments
  class DestroyService
    attr_reader :comment

    def initialize(comment)
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
        { card: CardSerializer.render_as_hash(comment.resource) }
      )
    end
  end
end
