module Tasks
  class UpdateService
    attr_reader :task, :params, :errors

    def initialize(task, params)
      @task = task
      @params = params
    end

    def call
      task.update!(params)
    rescue StandardError
      @errors = task.errors
      false
    end
  end
end
