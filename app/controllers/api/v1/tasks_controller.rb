module Api
  module V1
    class TasksController < ApplicationController
      def create
        service = Tasks::CreateService.new(@current_user, create_params)

        if service.call
          render json: {
            success: true,
            task: TaskSerializer.render_as_hash(service.task),
            card: CardSerializer.render_as_hash(service.task.card)
          }
        else
          render json: { success: false, errors: service.errors }, status: :unprocessable_entity
        end
      end

      def update
        service = Tasks::UpdateService.new(@current_user, task, update_params)

        if service.call
          render json: {
            success: true,
            task: TaskSerializer.render_as_hash(service.task),
            card: CardSerializer.render_as_hash(service.task.card)
          }
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
        Cards::UpdateService.new(@current_user, {
                                   id: params[:card_id],
                                   description: params[:description]
                                 }).call
        card.reload
        service = Openai::TaskService.new(project, card, current_user: @current_user)

        if service.call
          render json: { success: true, card: CardSerializer.render_as_hash(card) }
        else
          render json: { success: false }, status: :unprocessable_entity
        end
      end

      def destroy
        service = Tasks::DestroyService.new(@current_user, task)
        if service.call
          render json: { success: true, card: CardSerializer.render_as_hash(service.task.card) }
        else
          render json: { success: false, errors: service.errors }, status: :unprocessable_entity
        end
      end

      private

      def card
        @card ||= Card.find(params[:card_id])
      end

      def task
        @task ||= Task.find_by(id: params[:id])
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
