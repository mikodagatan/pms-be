module Api
  module V1
    class TasksController < ApplicationController
      def create
        service = Tasks::CreateService.new(card, create_params)

        if service.call
          render json: { success: true, task: TaskSerializer.render_as_hash(service.task) }
        else
          render json: { success: false, errors: service.errors }, status: :unprocessable_entity
        end
      end

      def update
        service = Tasks::UpdateService.new(task, update_params)

        if service.call
          render json: { success: true, task: TaskSerializer.render_as_hash(service.task) }
        else
          render json: { success: false, errors: service.errors }, status: :unprocessable_entity
        end
      end

      def move_task
        service = Tasks::MoveTaskService.new(move_task_params)

        if service.call
          render json: { success: true }
        else
          render json: { success: false }, status: :unprocessable_entity
        end
      end

      def generate_tasks
        project = Project.find(params[:project_id])
        Cards::UpdateService.new({
                                   id: params[:card_id],
                                   description: params[:description]
                                 }).call
        card.reload
        service = Openai::TaskService.new(project, card)

        if service.call
          render json: { success: true, card: CardSerializer.render_as_hash(card) }
        else
          render json: { success: false }, status: :unprocessable_entity
        end
      end

      def destroy
        task.destroy

        render json: { success: true }
      end

      private

      def card
        @card ||= Card.find(params[:card_id])
      end

      def task
        @task ||= Task.find(params[:id])
      end

      def create_params
        params.permit(:card_id, :name, :type)
      end

      def update_params
        params.permit(:id, :name, :checked)
      end

      def move_task_params
        params.permit(:task_id, :destination_index)
      end
    end
  end
end