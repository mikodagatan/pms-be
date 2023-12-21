module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :authorize_user, only: %i[show update]

      def index
        projects = @current_user.projects

        render json: { success: true, projects: ProjectSerializer.render_as_hash(projects) }
      end

      def show
        if project
          render json: { success: true, project: ProjectSerializer.render_as_hash(project) }
        else
          render json: { success: false }, status: :not_found
        end
      end

      def create
        service = Projects::CreateService.new(@current_user, create_params)

        if service.call
          render json: { success: true, project: ProjectSerializer.render_as_hash(service.project) }
        else
          render json: { success: false, errors: service.errors }, status: :unprocessable_entity
        end
      end

      def update
        service = Projects::UpdateService.new(project, update_params)
        if service.call
          render json: { success: true }
        else
          render json: { success: false, errors: service.errors }, status: :unprocessable_entity
        end
      end

      private

      def create_params
        params.permit(:name, :code)
      end

      def update_params
        params.permit(:name, :code, user_ids: [])
      end

      def project
        @project ||= Project.find_by(id: params[:id])
      end

      def authorize_user
        authorized = @current_user.projects.include?(project)

        return if authorized

        render json: { error: 'You are unauthorized to access this project' }, status: :unauthorized
      end
    end
  end
end
