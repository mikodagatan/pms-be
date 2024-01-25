require 'rails_helper'

RSpec.describe Projects::CreateService do
  let(:user) { create(:user) }

  describe '#call' do
    let(:service) { described_class.new(user, params) }
    context 'when valid project' do
      let(:params) { { name: 'project name', code: 'CODE' } }

      it 'creates a project' do
        expect do
          service.call
        end.to change(Project, :count).by(1)
      end

      it 'creates 3 columns for the project' do
        expect do
          service.call
        end.to change(Column, :count).by(3)
      end

      it 'creates relationship for user and project' do
        expect do
          service.call
        end.to change(ProjectUser, :count).by(1)
      end
    end

    context 'when duplicate code' do
      let!(:project) { create(:project, code: 'CODE') }
      let(:params) { { name: 'project name', code: 'CODE' } }

      it 'returns false and errors' do
        service.call

        expect(service.errors).to eq({ code: ['has already been taken'] })
      end
    end
  end
end
