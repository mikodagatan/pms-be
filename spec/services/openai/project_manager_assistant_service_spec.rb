require 'rails_helper'

RSpec.describe Openai::ProjectManagerAssistantService do
  describe '.call' do
    context 'with no modify' do
      it 'returns assistant id' do
        expect(described_class.call).to eq('project-manager-assistant-id')
      end
    end

    context 'with modify' do
      it 'modifies assistant in openai' do
        allow_any_instance_of(OpenAI::Client).to receive_message_chain(:assistants, :modify).and_return(true)

        expect(described_class.call).to eq('project-manager-assistant-id')
      end
    end
  end
end
