require 'rails_helper'

RSpec.describe Column, type: :model do
  describe 'associations' do
    it { should belong_to(:project) }
    it { should have_many(:cards).dependent(:destroy) }
  end
end
