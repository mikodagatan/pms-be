module Tasks
  class MoveTaskService
    attr_reader :task

    def initialize(params)
      @task = Task.find(params[:task_id])
      @destination_index = params[:destination_index]
    end

    def call
      ActiveRecord::Base.transaction do
        task.insert_at(@destination_index.to_i + 1)
        broadcast
      end
      true
    rescue StandardError
      false
    end

    private

    def broadcast
      ActionCable.server.broadcast(
        "card_channel_#{task.card.id}",
        { card: CardSerializer.render_as_hash(task.card) }
      )
    end
  end
end
