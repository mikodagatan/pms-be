module Tasks
  class DestroyService
    attr_reader :current_user, :task, :errors

    def initialize(current_user, task)
      @current_user = current_user
      @task = task
      @errors = []
    end

    def call
      ActiveRecord::Base.transaction do
        create_history
        task.destroy
      end
    rescue StandardError => e
      @errors << e
      false
    end

    def create_history
      CardHistories::DeleteTaskService.new(current_user, task).call
    end
  end
end
