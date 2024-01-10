module CardHistories
  class CreateCardService
    attr_reader :current_user, :card

    def initialize(current_user, card)
      @current_user = current_user
      @card = card
    end

    def call
      history = card.histories.build(
        attr: :card,
        action: :create_action,
        user: current_user,
        output: "<strong>#{current_user.full_name}</strong> has created the card."
      )
      history.save!
    end
  end
end
