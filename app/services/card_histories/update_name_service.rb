module CardHistories
  class UpdateNameService
    attr_reader :current_user, :card

    def initialize(current_user, card)
      @current_user = current_user
      @card = card
    end

    def call
      history = card.histories.build(
        attr: :name,
        action: :update_action,
        user: current_user,
        from: card.name_was,
        to: card.name,
        output: "<strong>#{current_user.full_name}</strong> changed the name of the card from <strong>#{card.name_was}</strong> to <strong>#{card.name}</strong>"
      )
      history.save!
    end
  end
end
