module Openai
  class CreateCardTaskService
    attr_reader :params, :card, :column

    def initialize(card, type, params)
      @card = card
      @params = params
      @tasks_type = type == 'UserTestingTask' ? 'user_testing_tasks' : 'developer_tasks'
    end

    def call
      task = card.public_send(@tasks_type).build(params)

      return unless task.save

      task.id
    end
  end
end
