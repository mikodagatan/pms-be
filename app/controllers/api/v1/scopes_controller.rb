module Api
  module V1
    class ScopesController < ApplicationController
      def update
        service = Projects::UpdateScopeService.new(project, scope_params)

        if service.call
          render json: { success: true }
        else
          render json: { success: false }, status: :unprocessable_entity
        end
      end

      def generate_cards
        Projects::UpdateScopeService.new(project, scope_params).call
        service = Openai::TaskService.new(project, params[:scope])

        if service.call
          project.reload
          render json: { success: true, project: ProjectSerializer.render_as_hash(project) }
        else
          render json: { success: false }, status: :unprocessable_entity
        end
      end

      private

      def project
        @project ||= Project.find(params[:project_id])
      end

      def scope_params
        params.permit(:scope)
      end
    end
  end
end
