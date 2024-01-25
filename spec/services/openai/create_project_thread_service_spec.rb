require 'rails_helper'

RSpec.describe Openai::CreateProjectThreadService do
  describe '#call' do
    let(:service) { described_class.new(project) }

    context 'when thread is present' do
      let(:thread) { create(:openai_thread) }
      let(:project) { thread.project }

      it 'returns the thread id' do
        expect(service.call).to eq(thread.thread_id)
      end
    end

    context 'when thread is not present' do
      let(:project) { create(:project) }

      it 'creates a thread in openai' do
        allow_any_instance_of(OpenAI::Client).to receive_message_chain(:threads, :create).and_return('id' => '123')

        expect(service.call).to eq('123')
      end
    end
  end
end
