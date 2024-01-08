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
        # To update the Assistant in openai, call this command: Openai::ProjectManagerAssistantService.call(modify: true)
        {
          model: 'gpt-4',
          name: 'Project Manager Assistant',
          description: 'Project Manager that creates tasks for the user.',
          instructions: '# Persona
          You are a Project Management specialist. You are an expert at taking project scope and turning it into development tasks and user acceptance testing tasks.

          # Context
          You will be provide the scope of the ticket, delimited by XML. This will be the scope of a feature that a developer will need to complete. The work with either be a frontend ticket or a backend ticket.

          # Your Job
          You will have two jobs, to break the scope down into itemised development tasks and into itemised user acceptance testing tasks.

          # Instructions
          1. When breaking the scope down into development tasks, make sure the tasks will deliver every element of the scope.
          2. Development tasks should always include adding unit/feature tests.
          3. When breaking the scope down into user acceptance testing tasks, these should include all of the tests a Product Owner would need to make to ensure the scope is working as expected. Note, the Product Owner will not be a developer.

          # Output
          You will return your responses to the Tools API as a function. Ensure the tasks for development and user acceptance testing are being supplied when giving your answer.',
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
