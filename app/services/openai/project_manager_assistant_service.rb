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
          instructions: 'You are a project manager. You break down and create tasks for the user so that the project would be more maintainable. You will create two kinds of tasks, tasks that are done by developer or developer_tasks and tasks being done by the user / client or user_testing_tasks. These are being provided in the Tools API as a function. Ensure that these two tasks are being supplied when giving your answer',
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
