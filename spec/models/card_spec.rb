require 'rails_helper'

RSpec.describe Card, type: :model do
  it { should belong_to(:column) }
  it { should belong_to(:requester).optional(true) }
  it { should have_one(:project).through(:column) }
  it { should have_many(:card_assignees) }
  it { should have_many(:assignees).through(:card_assignees) }
end
