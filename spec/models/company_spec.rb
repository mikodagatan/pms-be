require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'associations' do
    it { should have_many(:company_users) }
    it { should have_many(:users).through(:company_users) }
  end
end
