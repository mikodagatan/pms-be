require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :request do
  let!(:user) { create(:user) }
  let!(:card) { create(:card) }

  describe '#create' do
    context 'when creating DeveloperTask' do
      let(:params) { { card_id: card.id, name: 'new task name', type: 'DeveloperTask' } }

      it 'returns true, task, and card' do
        expect do
          post '/api/v1/tasks', params:, headers: auth_headers(user)
        end.to have_broadcasted_to("card_channel_#{card.id}").from_channel(CardChannel)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: true })
        expect(parsed_response[:card]).to include({ name: card.name })
        expect(parsed_response[:task]).to include({ name: 'new task name' })
      end
    end

    context 'when creating UserTestingTask' do
      let(:params) { { card_id: card.id, name: 'new task name', type: 'UserTestingTask' } }

      it 'returns true, task, and card, broadcasts the create' do
        expect do
          post '/api/v1/tasks', params:, headers: auth_headers(user)
        end.to have_broadcasted_to("card_channel_#{card.id}").from_channel(CardChannel)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: true })
        expect(parsed_response[:card]).to include({ name: card.name })
        expect(parsed_response[:task]).to include({ name: 'new task name' })
      end
    end

    context 'when creating incorrect task type' do
      let(:params) { { card_id: card.id, name: 'new task name', type: 'ErrorTask' } }

      it 'returns false, errors' do
        post '/api/v1/tasks', params:, headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: false })
        expect(parsed_response).to include({ errors: { error: "The single-table inheritance mechanism failed to locate the subclass: 'ErrorTask'. This error is raised because the column 'type' is reserved for storing the class in case of inheritance. Please rename this column if you didn't intend it to be used for storing the inheritance class or overwrite Task.inheritance_column to use another column for that information." } })
      end
    end
  end

  describe '#update' do
    let!(:task) { create(:task, card:) }
    context 'when task valid' do
      let(:params) { { id: task.id, name: 'updated name', checked: true } }

      it 'returns true, task, card, broadcasts the update' do
        expect do
          put '/api/v1/tasks/update', params:, headers: auth_headers(user)
        end.to have_broadcasted_to("card_channel_#{task.card_id}").from_channel(CardChannel)

        parsed_response = from_json(response.body)

        expect(parsed_response).to include({ success: true })
        expect(parsed_response[:card]).to include({ name: card.name })
        expect(parsed_response[:task]).to include({ name: 'updated name' })
      end
    end
  end

  describe '#move_task' do
    let!(:task) { create(:task, card:) }
    let!(:other_tasks) { create_list(:task, 4, card:) }

    context 'when move task is valid' do
      let(:params) { { task_id: task.id, destination_index: 4 } }

      it 'returns true' do
        expect do
          post '/api/v1/tasks/move_task', params:, headers: auth_headers(user)
        end.to have_broadcasted_to("card_channel_#{task.card_id}").from_channel(CardChannel)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: true })
      end
    end
  end

  describe '#destroy' do
    let!(:task) { create(:task, card:) }

    context 'when task is found' do
      it 'returns true' do
        expect do
          delete "/api/v1/tasks/#{task.id}", headers: auth_headers(user)
        end.to have_broadcasted_to("card_channel_#{card.id}").from_channel(CardChannel)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: true })
      end
    end

    context 'when task is not found' do
      it 'returns false, errors' do
        delete '/api/v1/tasks/1000', headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: false })
        expect(parsed_response).to include({ errors: { error: "undefined method `card' for nil:NilClass" } })
      end
    end
  end

  describe '#generate_tasks' do
    # CREATE GENERATE TASKS
    context 'when openai creates tasks' do
      let(:params) do
        {
          card_id: card.id,
          project_id: card.project.id,
          description: 'new description'
        }
      end

      before do
        allow_any_instance_of(OpenAI::Client).to receive_message_chain(:runs,
                                                                       :retrieve).and_return(open_ai_mock)
        allow_any_instance_of(OpenAI::Client).to receive_message_chain(:messages,
                                                                       :create).and_return(true)
        allow_any_instance_of(OpenAI::Client).to receive_message_chain(:threads,
                                                                       :create).and_return({ 'id' => 12_345 })
        allow_any_instance_of(OpenAI::Client).to receive_message_chain(:runs,
                                                                       :create).and_return({ 'id' => 12_345 })
        allow_any_instance_of(OpenAI::Client).to receive_message_chain(:runs,
                                                                       :cancel).and_return({ 'id' => 12_345 })
        allow_any_instance_of(OpenAI::Client).to receive_message_chain(:runs,
                                                                       :submit_tool_outputs).and_return(true)
        stub_const('ENV', ENV.to_hash.merge('PROJECT_MANAGER_ASSISTANT_ID' => '123456'))
      end

      it 'creates tasks and returns true and card' do
        expect do
          post '/api/v1/tasks/generate_tasks', params:, headers: auth_headers(user)
        end.to change(Task, :count).by(4)

        parsed_response = from_json(response.body)

        expect(parsed_response).to include({ success: true })
        expect(parsed_response[:card]).to include({ description: 'new description' })
      end
    end
  end
end
