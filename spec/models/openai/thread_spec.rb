require 'rails_helper'

RSpec.describe Openai::Thread, type: :model do
  describe 'associations' do
    it { should belong_to(:project) }
  end

  describe 'validations' do
    subject { build(:openai_thread) }
    it { should validate_presence_of(:thread_id) }
    it { should validate_uniqueness_of(:project_id) }
  end
end
