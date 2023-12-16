require 'rails_helper'

RSpec.describe Jwt do
  let(:payload) { { user_id: 1 } }
  describe '.encode' do
    it 'encodes a payload into a JWT' do
      encoded_jwt = described_class.encode(payload)

      expect(encoded_jwt).to be_a(String)
    end
  end

  describe '.decode' do
    it 'decodes a JWT into a payload' do
      encoded_jwt = described_class.encode(payload)
      decoded_payload = described_class.decode(encoded_jwt)

      expect(decoded_payload).to include({ 'user_id' => 1 })
    end

    it 'returns nil for an expired token' do
      encoded_jwt = described_class.encode(payload.merge(exp: 1.hour.ago))
      decoded_payload = described_class.decode(encoded_jwt)

      expect(decoded_payload).to be_nil
    end
  end
end
