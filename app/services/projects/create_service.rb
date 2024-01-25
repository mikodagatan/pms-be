module Projects
  class CreateService
    attr_reader :current_user, :params, :project, :errors

    def initialize(current_user, params)
      @current_user = current_user
      @params = params
    end

    def call
      ActiveRecord::Base.transaction do
        @project = current_user.projects.build(params)
        project.save!
        current_user.projects << project
        add_columns(project)
      end
      true
    rescue StandardError
      @errors = @project.errors&.to_hash
      false
    end

    def add_columns(project)
      project.columns.create(name: 'To Do', position: 1)
      project.columns.create(name: 'Doing', position: 2)
      project.columns.create(name: 'Done', position: 3)
    end
  end
end
