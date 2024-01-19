require 'rails_helper'

RSpec.describe CardHistory, type: :model do
  describe 'associations' do
    it { should belong_to(:card) }
    it { should belong_to(:user) }
  end

  describe 'enums' do
    it { should define_enum_for(:action).with_values(%i[create_action update_action destroy_action move_action]) }
    it { should define_enum_for(:action_status).with_values(%i[normal improved worsened]) }
  end
end
