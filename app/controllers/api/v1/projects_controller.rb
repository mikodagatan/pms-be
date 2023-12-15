module Api
  module V1
    class ProjectsController < ApplicationController
      def index
        project = Project.last

        render json: ProjectSerializer.render(project)
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
