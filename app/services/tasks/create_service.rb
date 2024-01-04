module Tasks
  class CreateService
    attr_reader :card, :params, :task, :errors

    def initialize(card, params)
      @card = card
      @params = params
    end

    def call
      @task = Task.new(params)
      task.save!
    rescue StandardError
      @errors = task.errors
      false
    end
  end
end
