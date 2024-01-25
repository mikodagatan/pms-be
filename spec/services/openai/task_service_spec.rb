require 'rails_helper'

RSpec.describe Openai::TaskService do
  let!(:project) { create(:project) }
  let!(:card) { create(:card) }
  let!(:user) { create(:user) }
  describe '#call' do
    let(:service) { described_class.new(project, card, current_user: user) }
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

    it 'creates tasks' do
      expect do
        service.call
      end.to change(Task, :count).by(4)
    end
  end
end
