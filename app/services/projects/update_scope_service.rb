module Projects
  class UpdateScopeService
    attr_reader :project, :params

    def initialize(project, params)
      @project = project
      @params = params
    end

    def call
      project.update(params)
    end
  end
end
