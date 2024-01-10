module Tasks
  class CreateService
    attr_reader :current_user, :params, :task, :errors

    def initialize(current_user, params)
      @current_user = current_user
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        @task = Task.new(params)
        task.save!
        create_history
      end
    rescue StandardError
      @errors = task.errors
      false
    end

    private

    def create_history
      CardHistories::CreateTaskService.new(current_user, task).call
    end
  end
end
