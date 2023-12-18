require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { should have_many(:columns) }
    it { should have_many(:cards).through(:columns) }
    it { should have_many(:project_users) }
    it { should have_many(:users).through(:project_users) }
  end
end
