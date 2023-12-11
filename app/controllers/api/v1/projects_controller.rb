module Api
  module V1
    class ProjectsController < ApplicationController
      def index
        project = Project.last

        render json: ProjectSerializer.render(project)
      end

    end
  end
end
