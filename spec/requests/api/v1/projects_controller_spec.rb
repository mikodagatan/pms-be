require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :request do
  let!(:user) { create(:user) }

  describe '#index' do
    let!(:project) { create(:project) }

    before do
      project.users = [user]
      project.save
    end

    it 'shows projects related to user' do
      get '/api/v1/projects', headers: auth_headers(user)

      parsed_response = from_json(response.body)

      expect(parsed_response).to include({ success: true })
      expect(parsed_response[:projects].first).to include({ name: project.name })
    end
  end

  describe '#show' do
    context 'when project is found' do
      let!(:project) { create(:project) }

      before do
        project.users = [user]
        project.save
      end

      it 'returns true and the project' do
        get "/api/v1/projects/#{project.id}", headers: auth_headers(user)

        parsed_response = from_json(response.body)

        expect(parsed_response).to include({ success: true })
        expect(parsed_response[:project]).to include({ name: project.name })
      end
    end

    context 'when project is not found' do
      it 'returns unauthorization error' do
        get '/api/v1/projects/1000', headers: auth_headers(user)

        parsed_response = from_json(response.body)

        expect(parsed_response).to include({ error: 'You are unauthorized to access this project' })
      end
    end
  end

  describe '#create' do
    context 'when project is valid' do
      let(:params) { { name: 'sample name', code: 'CODE' } }
      it 'returns true and the project' do
        post '/api/v1/projects', params:, headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: true })
        expect(parsed_response[:project]).to include({ name: 'sample name', code: 'CODE' })
      end
    end

    context 'when project duplicates the code' do
      let!(:project) { create(:project, code: 'CODE') }
      let(:params) { { name: 'sample name', code: 'CODE' } }

      it 'returns false and errors' do
        post '/api/v1/projects', params:, headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: false })
        expect(parsed_response).to include({ errors: { code: ['has already been taken'] } })
      end
    end
  end

  describe '#update' do
    let(:project) { create(:project) }

    before do
      project.users = [user]
      project.save
    end

    context 'when project is valid' do
      let(:params) { { id: project.id, name: 'updated name', code: 'UPDTE', user_ids: [user.id] } }

      it 'returns true' do
        put '/api/v1/projects/update', params:, headers: auth_headers(user)

        parsed_response = from_json(response.body)

        expect(parsed_response).to include({ success: true })
      end
    end

    context 'when project duplicates code' do
      let!(:project2) { create(:project, code: 'UPDTE') }
      let(:params) { { id: project.id, name: 'updated name', code: 'UPDTE' } }

      it 'returns false and errors' do
        put '/api/v1/projects/update/', params:, headers: auth_headers(user)

        parsed_response = from_json(response.body)
        expect(parsed_response).to include({ success: false })
        expect(parsed_response).to include({ errors: { code: ['has already been taken'],
                                                       error: 'Validation failed: Code has already been taken' } })
      end
    end
  end
end
