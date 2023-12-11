require 'rails_helper'

RSpec.describe Card, type: :model do
  it { should belong_to(:column) }
  it { should have_one(:project).through(:column) }
end
