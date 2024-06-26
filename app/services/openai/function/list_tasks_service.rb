module Openai
  module Function
    class ListTasksService
      class << self
        def call(
          current_user:,
          card:,
          developer_tasks:,
          user_testing_tasks:
        )
          card.developer_tasks.delete_all
          card.user_testing_tasks.delete_all
          developer_tasks.each do |task|
            Openai::CreateCardTaskService.new(current_user, card, 'DeveloperTask', task).call
          end
          user_testing_tasks.map do |task|
            Openai::CreateCardTaskService.new(current_user, card, 'UserTestingTask', task).call
          end
          CardHistories::GenerateAiService.new(current_user, card).call
          'Tasks Created'
        end

        def params
          # NOTE: When changing the params, call the Openai::ProjectManagerAssistantService.call(modify: true)
          # to update the Assistant
          {
            name: 'list_tasks',
            description: 'List tasks coming from scope. Lists down developer tasks and user testing tasks.',
            parameters: {
              type: :object,
              properties: {
                developer_tasks: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      name: {
                        type: :string,
                        description: 'Describes what needs to be done for by the developer for the task. List down all the details as much as possible.'
                      }
                    },
                    required: %w[name]
                  }
                },
                user_testing_tasks: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      name: {
                        type: :string,
                        description: 'Describes what needs to be done by the user/client to check what the developer has done in the developer_tasks. List down all the details as much as possible.'
                      }
                    },
                    required: [:name]
                  }
                }
              },
              required: %w[developer_tasks user_testing_tasks]
            }
          }
        end
      end
    end
  end
end
