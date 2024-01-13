module Cards
  class CreateService
    attr_reader :current_user, :params, :card, :errors

    def initialize(current_user, params)
      @params = params
      @current_user = current_user
    end

    def call
      ActiveRecord::Base.transaction do
        @card = column.cards.build(params)
        @card.save!
        card.insert_at(1)
        create_history
        broadcast
      end
    rescue StandardError => e
      @errors = @card.errors.to_hash
      @errors[:error] = e
      false
    end

    private

    def column
      @column ||= Column.find(params[:column_id])
    end

    def create_history
      service = CardHistories::CreateCardService.new(current_user, card)
      service.call
    end

    def broadcast
      ActionCable.server.broadcast(
        "project_channel_#{column.project.id}",
        { project: ProjectSerializer.render_as_hash(column.project) }
      )
    end
  end
end
