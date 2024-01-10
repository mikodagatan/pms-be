module Cards
  class UpdateService
    attr_reader :current_user, :card, :params

    def initialize(current_user, params)
      @current_user = current_user
      @card = Card.find(params[:id])
      @params = params.except(:id)
    end

    def call
      ActiveRecord::Base.transaction do
        card.assign_attributes(update_params)
        create_history
        card.save
        card.assignees = card_assignees if params[:assignee_ids]
      end
      true
    rescue StandardError
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
    end
  end
end
