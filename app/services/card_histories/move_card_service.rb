module CardHistories
  class MoveCardService
    attr_reader :card, :source_column, :destination_column

    def initialize(card, source_column, destination_column)
      @card = card
      @source_column = source_column
      @destination_column = destination_column
    end

    def call
      history = card.histories.build(
        attr: :card,
        action: :move_action,
        user: current_user,
        output:
      )
      history.save!
    end

    def output
      "<strong>#{current_user.full_name}</strong> has moved the card" \
      "from <strong>#{source_column.name}</strong> " \
      "to <strong>#{destination_column.name}</strong>"
    end
  end
end
