require 'rails_helper'

RSpec.describe Projects::UpdateService do
  let!(:project) { create(:project, code: 'CODE') }
  let!(:project2) { create(:project, code: 'CODE2') }

  describe '#call' do
    let(:service) { described_class.new(project, params) }
    context 'when valid project' do
      let(:params) { { name: 'project name', code: 'CODE' } }

      it 'updates the project' do
        service.call
        project.reload
        expect(project.name).to eq('project name')
      end
    end

    context 'when duplicate code' do
      let(:params) { { name: 'project name', code: 'CODE2' } }

      it 'returns false and errors' do
        service.call

        expect(service.errors).to eq({ code: ['has already been taken'],
                                       error: 'Validation failed: Code has already been taken' })
      end
    end
  end
end
