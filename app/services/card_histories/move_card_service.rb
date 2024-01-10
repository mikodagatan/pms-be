module CardHistories
  class MoveCardService
    attr_reader :current_user, :card, :source_column, :destination_column

    def initialize(current_user, card, source_column, destination_column)
      @current_user = current_user
      @card = card
      @source_column = source_column
      @destination_column = destination_column
    end

    def call
      history = card.histories.build(
        attr: :card,
        action: :move_action,
        user: current_user,
        output:,
        action_status:
      )

      history.save!
    end

    def output
      "<strong>#{current_user.full_name}</strong> has moved the card " \
      "from <strong>#{source_column.name}</strong> " \
      "to <strong>#{destination_column.name}</strong>"
    end

    def action_status
      if destination_column.position > source_column.position
        :improved
      elsif destination_column.position < source_column.position
        :worsened
      end
    end
  end
end
