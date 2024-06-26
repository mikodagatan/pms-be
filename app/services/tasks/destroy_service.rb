module Tasks
  class DestroyService
    attr_reader :current_user, :task, :errors

    def initialize(current_user, task)
      @current_user = current_user
      @task = task
      @errors = {}
    end

    def call
      ActiveRecord::Base.transaction do
        create_history
        task.destroy
        broadcast
      end
      true
    rescue StandardError => e
      @errors[:error] = e.message
      false
    end

    def create_history
      CardHistories::DeleteTaskService.new(current_user, task).call
    end

    def broadcast
      ActionCable.server.broadcast(
        "card_channel_#{task.card.id}",
        { card: CardSerializer.render_as_hash(task.card),
          sender_id: current_user.id }
      )
    end
  end
end
