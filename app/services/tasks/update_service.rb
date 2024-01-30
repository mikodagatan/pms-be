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
        broadcast
      end
      true
    rescue StandardError => e
      @errors = task&.errors || {}
      @errors[:error] = e.message
      false
    end

    private

    def create_history
      CardHistories::UpdateTaskNameService.new(current_user, task).call if task.name_changed?
      CardHistories::CheckTaskService.new(current_user, task).call if task.checked_changed?
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
