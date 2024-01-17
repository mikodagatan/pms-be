module CardHistories
  class CreateTaskService
    attr_reader :current_user, :card, :task, :use_ai

    def initialize(current_user, task, use_ai: false)
      @current_user = current_user
      @task = task
      @card = task.card
      @use_ai = use_ai
    end

    def call
      history = card.histories.build(
        attr: :card,
        action: :create_action,
        user: current_user,
        to: task.name,
        ai: use_ai,
        output:
      )
      history.save!
    end

    private

    def output
      "<strong>#{current_user.full_name}</strong> has created the #{task_type}#{with_ai_string}: <strong>#{task.name}</strong>"
    end

    def task_type
      task.type.underscore.humanize.downcase
    end

    def with_ai_string
      use_ai ? ' with AI' : ''
    end
  end
end
