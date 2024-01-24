module CardHistories
  class DeleteTaskService
    attr_reader :current_user, :card, :task

    def initialize(current_user, task)
      @current_user = current_user
      @task = task
      @card = task.card
    end

    def call
      history = card.histories.build(
        attr: :task,
        action: :destroy_action,
        user: current_user,
        to: task.name,
        output:
      )
      history.save!
    end

    private

    def output
      "<strong>#{current_user.full_name}</strong> has deleted the #{task_type}: <strong>#{task.name}</strong>"
    end

    def task_type
      task.type.underscore.humanize.downcase
    end
  end
end
