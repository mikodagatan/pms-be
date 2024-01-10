module Cards
  class MoveCardService
    attr_reader :current_user, :project, :card

    def initialize(current_user, params)
      @current_user = current_user
      @project = Project.find(params[:project_id])
      @card = Card.find(params[:card_id])
      @source_column_id = params[:source_column_id]
      @source_index = params[:source_index]
      @destination_column_id = params[:destination_column_id]
      @destination_index = params[:destination_index]
    end

    def call
      ActiveRecord::Base.transaction do
        card.remove_from_list
        card.update(column: destination_column) unless same_column?
        create_history
        card.insert_at(@destination_index + 1)
      end
      true
    rescue StandardError
      false
    end

    private

    def same_column?
      source_column == destination_column
    end

    def source_column
      @source_column ||= Column.find(@source_column_id)
    end

    def destination_column
      @destination_column ||= Column.find(@destination_column_id)
    end

    def create_history
      CardHistories::MoveCardService.new(current_user, source_column, destination_column).call unless same_column?
    end
  end
end
