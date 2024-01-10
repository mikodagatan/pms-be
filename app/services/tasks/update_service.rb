module Tasks
  class UpdateService
    attr_reader :current_user, :task, :params, :errors

    def initialize(current_user, task, params)
      @current_user = current_user
      @task = task
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        task.assign_attributes(params)
        create_history
        task.save
      end
    rescue StandardError
      @errors = task.errors
      false
    end

    private

    def create_history
      CardHistories::UpdateTaskNameService.new(current_user, task).call if task.name_changed?
      CardHistories::CheckTaskService.new(current_user, task).call if task.checked_changed?
    end
  end
end
