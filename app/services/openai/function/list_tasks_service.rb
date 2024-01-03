module Openai
  module Function
    class ListTasksService
      class << self
        def call(project:, tasks:)
          tasks.map do |task|
            id = Openai::CreateProjectCardService.new(project, task).call
            "Card Created: #{id}"
          end.join(', ')
        end

        def params
          # NOTE: When changing the params, call the Openai::ProjectManagerAssistantService.call(modify: true)
          # to update the Assistant
          {
            name: 'list_tasks',
            description: 'List tasks coming from scope',
            parameters: {
              type: :object,
              properties: {
                tasks: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      name: {
                        type: :string,
                        description: 'Name of the task, describes task briefly'
                      },
                      description: {
                        type: 'string',
                        description: 'Describes what needs to be done for the tasks. List down all the details as much as possible. If need to be step-by-step, list them down. Make sure to list them down in html format. E.g. <h1>Steps</h1><ol><li>Step 1</li><li>Step 2</li></ol>'
                      }
                    },
                    required: %w[name description]
                  }
                }
              },
              required: ['tasks']
            }
          }
        end
      end
    end
  end
end
