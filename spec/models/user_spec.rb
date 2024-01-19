require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:company_users) }
    it { should have_many(:companies).through(:company_users) }
    it { should have_many(:project_users) }
    it { should have_many(:projects).through(:project_users) }
    it { should have_many(:card_assignees).with_foreign_key(:assignee_id) }
    it { should have_many(:mentioneds).class_name('Mention').with_foreign_key(:mentioned_id) }
    it { should have_many(:mentions).class_name('Mention').with_foreign_key(:commenter_id) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_uniqueness_of(:username) }

    describe 'email format' do
      context 'when email format is incomplete' do
        let(:user) { build(:user, email: 'user@') }

        it 'should return error' do
          user.save
          expect(user.errors.full_messages).to eq(['Email is invalid'])
        end
      end
    end
  end
end
