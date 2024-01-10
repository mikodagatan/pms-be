module CardHistories
  class UpdateTaskNameService
    attr_reader :current_user, :card, :task

    def initialize(current_user, task)
      @current_user = current_user
      @task = task
      @card = task.card
    end

    def call
      history = card.histories.build(
        attr: :task,
        action: :update_action,
        user: current_user,
        from: task.name_was,
        to: task.name,
        output:
      )
      history.save!
    end

    private

    def output
      "<strong>#{current_user.full_name}</strong> has updated the task" \
      " from <strong>#{task.name_was}</strong> " \
      " to <strong>#{task.name}</strong>"
    end
  end
end
