module Cards
  class CreateService
    attr_reader :current_user, :params, :card, :errors

    def initialize(current_user, params)
      @params = params
      @current_user = current_user
    end

    def call
      ActiveRecord::Base.transaction do
        @card = column.cards.build(params)
        @card.save!
        create_history
      end
    rescue StandardError
      @errors = @card.errors
      false
    end

    private

    def column
      @column ||= Column.find(params[:column_id])
    end

    def create_history
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
