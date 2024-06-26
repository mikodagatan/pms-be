require 'rails_helper'

RSpec.describe CardAssignee, type: :model do
  describe 'associations' do
    it { should belong_to(:card) }
    it { should belong_to(:assignee) }
    it { should have_one(:mention).dependent(:destroy) }
  end
end
