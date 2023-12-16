require 'rails_helper'

RSpec.describe StateManager do
  subject(:state_manager) { described_class.new }
  let(:state) { SecureRandom.hex(16) }

  describe '#cache_state' do
    it 'caches the state in Redis' do
      state_manager.cache_state(state)
      expect(StateManager::REDIS.exists(state_manager.send(:state_key, state))).to be_truthy
    end
  end

  describe '#valid_state?' do
    context 'when state is valid' do
      before { state_manager.cache_state(state) }

      it 'returns true' do
        expect(state_manager.valid_state?(state)).to be_truthy
      end
    end

    context 'when state is not valid' do
      it 'returns false' do
        expect(state_manager.valid_state?(state)).to be_falsey
      end
    end
  end

  describe '#clear_state' do
    it 'clears the state from Redis' do
      state_manager.cache_state(state)
      state_manager.clear_state(state)
      expect(StateManager::REDIS.exists(state_manager.send(:state_key, state)).to_i).to eq(0)
    end
  end
end
