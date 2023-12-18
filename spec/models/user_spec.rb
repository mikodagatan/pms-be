require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:company_users) }
    it { should have_many(:companies).through(:company_users) }
    it { should have_many(:project_users) }
    it { should have_many(:projects).through(:project_users) }
  end
 
end
