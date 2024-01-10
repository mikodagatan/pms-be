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
      service = CardHistories::CreateCardService.new(current_user, card)
      service.call
    end
  end
end
