module Tasks
  class MoveTaskService
    attr_reader :current_user, :task, :errors

    def initialize(current_user, params)
      @current_user = current_user
      @task = Task.find_by(id: params[:task_id])
      @destination_index = params[:destination_index]
      @errors = {}
    end

    def call
      ActiveRecord::Base.transaction do
        task.insert_at(@destination_index.to_i + 1)
        broadcast
      end
      true
    rescue StandardError => e
      @errors[:error] = e.message
      false
    end

    private

    def broadcast
      ActionCable.server.broadcast(
        "card_channel_#{task.card.id}",
        { card: CardSerializer.render_as_hash(task.card),
          sender_id: current_user.id }
      )
    end
  end
end
