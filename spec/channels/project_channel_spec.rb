require 'rails_helper'

RSpec.describe ProjectChannel, type: :channel do
  let(:id) { '1' } # Sample ID for testing

  before do
    # Initialize the channel
    stub_connection(params: { id: })
  end

  it 'successfully subscribes to the project channel' do
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("project_channel_#{id}")
  end

  it 'unsubscribes from the project channel' do
    subscribe
    expect(subscription).to have_stream_from("project_channel_#{id}")
    unsubscribe
    expect(subscription).to_not have_stream_from("project_channel_#{id}")
  end
end
