module Cards
  class UpdateService
    attr_reader :card, :params

    def initialize(params)
      @card = Card.find(params[:id])
      @params = params.except(:id)
    end

    def call
      ActiveRecord::Base.transaction do
        @card.update!(update_params)
        @card.assignees = card_assignees if params[:assignee_ids]
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
  end
end
