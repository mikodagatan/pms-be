module Openai
  class TaskService
    attr_reader :project, :message, :client

    def initialize(project, message)
      @client = OpenAI::Client.new
      @message = message
      @project = project || Project.find_by(code: 'SMPL3')
    end

    def call
      ActiveRecord::Base.transaction do
        create_message

        poll_run_result(run_id)

        # # Alternatively retrieve the `run steps` for the run which link to the messages:
        # run_steps = client.run_steps.list(thread_id:, run_id:)

        # puts "RUN STEPS: #{run_steps}"

        # new_message_ids = run_steps['data'].filter_map do |step|
        #   if step['type'] == 'message_creation'
        #     step.dig('step_details', 'message_creation', 'message_id')
        #   end # Ignore tool calls, because they don't create new messages.
        # end

        # # Retrieve the individual messages
        # new_messages = new_message_ids.map do |msg_id|
        #   client.messages.retrieve(id: msg_id, thread_id:)
        # end

        # # Find the actual response text in the content array of the messages
        # new_messages.each do |msg|
        #   msg['content'].each do |content_item|
        #     case content_item['type']
        #     when 'text'
        #       puts content_item.dig('text', 'value')
        #     # Also handle annotations
        #     when 'image_file'
        #       # Use File endpoint to retrieve file contents via id
        #       id = content_item.dig('image_file', 'file_id')
        #     end
        #   end
        # end
        # new_messages
        true
      end
    rescue StandardError => e
      puts e
      false
    end

    private

    def thread_id
      @thread_id ||= Openai::CreateProjectThreadService.new(project).call
    end

    def assistant_id
      @assistant_id ||= Openai::ProjectManagerAssistantService.call
    end

    def run_id
      return @run_id if @run_id

      run_response = client.runs.create(thread_id:,
                                        parameters: {
                                          assistant_id:
                                        })
      @run_id = run_response['id']
      puts "runid: #{run_id}"
      @run_id
    end

    def poll_run_result(run_id)
      while true
        response = client.runs.retrieve(id: run_id, thread_id:)
        status = response['status']

        puts "STATUS: #{status}"

        case status
        when 'queued', 'in_progress', 'cancelling'
          sleep 1 # Wait one second and poll again
        when 'completed'
          break # Exit loop and report result to user
        when 'requires_action'
          handle_require_action(response)
          break
        when 'cancelled', 'failed', 'expired'
          puts response['last_error'].inspect
          break # or `exit`
        else
          puts "Unknown status response: #{status}"
          break
        end
      end
    end

    def handle_require_action(response)
      tools_to_call = response.dig('required_action', 'submit_tool_outputs', 'tool_calls')

      my_tool_outputs = tools_to_call.map do |tool|
        # Call the functions based on the tool's name
        function_name = tool.dig('function', 'name')
        arguments = JSON.parse(
          tool.dig('function', 'arguments'),
          { symbolize_names: true }
        )

        tool_output = call_tool_function(function_name, arguments)

        { tool_call_id: tool['id'], output: tool_output }
      end

      client.runs.submit_tool_outputs(thread_id:, run_id:,
                                      parameters: { tool_outputs: my_tool_outputs })
    end

    def call_tool_function(function_name, arguments)
      case function_name
      when 'list_tasks'
        Openai::Function::ListTasksService.call(project:, **arguments)
      end
    end

    def create_message
      client.messages.create(
        thread_id:,
        parameters: {
          role: 'user',
          content: message
        }
      )
    end
  end
end
