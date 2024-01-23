module Projects
  class UpdateService
    attr_accessor :project, :params, :errors

    def initialize(project, params)
      @project = project
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        project.update!(update_params)
        project.users = project_users if params[:user_ids]
      end
      true
    rescue StandardError
      @errors = project.errors
      false
    end

    private

    def update_params
      params.except(
        :id,
        :cards,
        :user_ids
      )
    end

    def project_users
      params[:user_ids]&.map do |id|
        User.find(id)
      end
    end
  end
end
