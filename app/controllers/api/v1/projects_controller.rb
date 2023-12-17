module Api
  module V1
    class ProjectsController < ApplicationController
      def index
        projects = Project.all

        render json: { success: true, projects: ProjectSerializer.render_as_hash(projects) }
      end

      def show
        project = Project.find_by(code: params[:code])

        if project
          render json: { success: true, project: ProjectSerializer.render_as_hash(project) }
        else
          render json: { success: false }, status: :not_found
        end
      end
    end
  end
end
