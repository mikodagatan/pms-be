module Cards
  class DestroyService
    attr_reader :current_user, :card

    def initialize(current_user, card)
      @current_user = current_user
      @card = card
    end

    def call
      card.destroy
      broadcast
    end

    private

    def broadcast
      ActionCable.server.broadcast(
        "project_channel_#{card.column.project.id}",
        { project: ProjectSerializer.render_as_hash(card.column.project),
          message: "#{current_user.full_name} deleted the card: #{card.name}" }
      )
    end
  end
end
