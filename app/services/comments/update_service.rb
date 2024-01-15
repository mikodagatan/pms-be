module Comments
  class UpdateService
    attr_reader :comment, :params, :errors

    def initialize(comment, params)
      @comment = comment
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        comment.update!(params)
        broadcast
      end
      true
    rescue StandardError
      @errors = comment.errors
      false
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
