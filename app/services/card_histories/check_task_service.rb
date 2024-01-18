module CardHistories
  class CheckTaskService
    attr_reader :current_user, :task, :card

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
        from: task.checked_was,
        to: task.checked,
        output:,
        action_status:
      )
      history.save!
    end

    private

    def output
      if task.checked
        "<strong>#{full_name}</strong> has marked the #{task_type} as done: <strong>#{task.name}</strong>"
      else
        "<strong>#{full_name}</strong> has marked the #{task_type} as unfinished: <strong>#{task.name}</strong>"
      end
    end

    def action_status
      task.checked ? :improved : :normal
    end

    def full_name
      current_user.full_name
    end

    def task_type
      task.type.underscore.humanize.downcase
    end
  end
end
