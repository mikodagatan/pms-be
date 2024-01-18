module Mentions
  class MentionAssigneesService
    attr_reader :current_user, :card

    def initialize(current_user, card)
      @current_user = current_user
      @card = card
    end

    def call
      card.card_assignees.each do |card_assignee|
        next if card_assignee.assignee == current_user

        Mentions::CreateService.new(current_user, card_assignee, card_assignee.assignee).call
      end
    end
  end
end
