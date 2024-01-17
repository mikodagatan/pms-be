module Openai
  class CreateCardTaskService
    attr_reader :current_user, :params, :card, :column

    def initialize(current_user, card, type, params)
      @current_user = current_user
      @card = card
      @params = params
      @tasks_type = type.underscore.pluralize
    end

    def call
      task = card.public_send(@tasks_type).build(params)

      return unless task.save

      task.id
    end
  end
end
