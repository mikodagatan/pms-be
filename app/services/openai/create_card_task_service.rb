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

      create_history(task)
      task.id
    end

    def create_history(task)
      CardHistories::CreateTaskService.new(current_user, task, use_ai: true).call
    end
  end
end
