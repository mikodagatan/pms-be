module CardHistories
  class GenerateAiService
    attr_reader :current_user, :card

    def initialize(current_user, card)
      @current_user = current_user
      @card = card
    end

    def call
      history = card.histories.build(
        attr: :generate_ai,
        action: :update_action,
        user: current_user,
        output:
      )
      history.save!
    end

    def output
      "<strong>#{current_user.full_name}</strong> has generated tasks through AI"
    end
  end
end
