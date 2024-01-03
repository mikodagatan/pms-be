module Openai
  class CreateProjectThreadService
    attr_reader :project, :client

    def initialize(project)
      @client = OpenAI::Client.new
      @project = project
    end

    def call
      return project.thread.thread_id if project.thread&.thread_id

      response = client.threads.create
      thread = Thread.create(project_id: project.id, thread_id: response['id'])
      thread.thread_id
    end
  end
end
