module Openai
  class ProjectManagerAssistantService
    class << self
      ID = ENV['PROJECT_MANAGER_ASSISTANT_ID']

      def call(modify: false)
        @modify = modify
        assistant_id
      end

      private

      def client
        @client ||= OpenAI::Client.new
      end

      def assistant_params
        {
          model: 'gpt-4',
          name: 'Project Manager Assistant',
          description: 'Project Manager that creates tasks for the user.',
          instructions: 'You are a project manager. You break down and create tasks for the user so that the project would be more maintainable.',
          tools: [
            {
              type: 'function',
              function: Openai::Function::ListTasksService.params
            }
          ]
        }
      end

      def assistant_id
        if ID
          # NOTE: Useful when changing instructions for assistant.
          modify_assistant if @modify

          return ID
        end

        response = client.assistants.create(parameters: assistant_params)
        puts response['id']
        response['id']
      end

      def modify_assistant
        client.assistants.modify(
          id: ID,
          parameters: assistant_params
        )
      end
    end
  end
end
