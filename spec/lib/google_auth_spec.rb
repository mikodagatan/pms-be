require 'rails_helper'

require 'uri'
require 'rack/utils'

RSpec.describe GoogleAuth do
  let(:google_auth) { described_class.new }

  describe '#initiate_oauth2' do
    it 'generates and caches state and returns Google authorization URL' do
      result = google_auth.initiate_oauth2

      expect(result).to start_with('https://accounts.google.com/o/oauth2/auth?')
    end
  end

  describe '#handle_callback' do
    let(:google_url) { google_auth.initiate_oauth2 }
    let(:state_param) do
      parsed_url = URI.parse(google_url)
      query_params = Rack::Utils.parse_nested_query(parsed_url.query)
      query_params['state']
    end

    context 'when state is valid' do
      before do
        allow_any_instance_of(described_class).to receive(:get_google_user_info).and_return(google_auth_params)
      end

      it 'returns Google user info' do
        result = google_auth.handle_callback({ state: state_param })

        expect(result).to eq(google_auth_params)
      end
    end

    context 'when state is invalid' do
      it 'raises StandardError' do
        allow(google_auth.state_manager).to receive(:valid_state?).and_return(false)

        expect do
          google_auth.handle_callback({ state: state_param })
        end.to raise_error(StandardError, 'Invalid state parameter')
      end
    end
  end
end
