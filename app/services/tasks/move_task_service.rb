module Tasks
  class MoveTaskService
    attr_reader :task

    def initialize(params)
      @task = Task.find(params[:task_id])
      @destination_index = params[:destination_index]
    end

    def call
      ActiveRecord::Base.transaction do
        task.insert_at(@destination_index + 1)
      end
      true
    rescue StandardError
      false
    end
  end
end
