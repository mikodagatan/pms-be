require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should have_many(:columns) }
  it { should have_many(:cards).through(:columns) }
  
end
