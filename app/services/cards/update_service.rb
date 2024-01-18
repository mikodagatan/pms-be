module Cards
  class UpdateService
    attr_reader :current_user, :card, :params, :errors

    def initialize(current_user, params)
      @current_user = current_user
      @card = Card.find(params[:id])
      @params = params.except(:id)
    end

    def call
      ActiveRecord::Base.transaction do
        card.assign_attributes(update_params)
        create_history
        mention_users if card.description_changed?
        card.save
        if params[:assignee_ids]
          card.assignees = card_assignees
          mention_assignees
        end
      end
      true
    rescue StandardError => e
      @errors = { error: e.to_s }
      false
    end

    private

    def card_assignees
      params[:assignee_ids]&.map do |id|
        User.find(id)
      end || []
    end

    def update_params
      params.except(:assignee_ids)
    end

    def create_history
      CardHistories::UpdateDescriptionService.new(current_user, card).call if card.description_changed?
      CardHistories::UpdateNameService.new(current_user, card).call if card.name_changed?
    end

    def mention_users
      Mentions::MentionUsersService.new(current_user, card).call
    end

    def mention_assignees
      Mentions::MentionAssigneesService.new(current_user, card).call
    end
  end
end
