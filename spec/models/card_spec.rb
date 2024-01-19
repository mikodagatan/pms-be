require 'rails_helper'

RSpec.describe Card, type: :model do
  describe 'associations' do
    it { should belong_to(:column) }
    it { should have_one(:project).through(:column) }
    it { should belong_to(:requester).class_name('User').optional(true) }
    it { should have_many(:card_assignees).dependent(:destroy) }
    it { should have_many(:assignees).through(:card_assignees) }
    it { should have_many(:developer_tasks).class_name('DeveloperTask').dependent(:destroy) }
    it { should have_many(:user_testing_tasks).class_name('UserTestingTask').dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:histories).class_name('CardHistory').dependent(:destroy) }
    it { should have_many(:mentions).dependent(:destroy) }
  end

  describe 'callbacks' do
    describe 'before_create' do
      describe '#assign_code' do
        let!(:card) { create(:card) }

        it 'should create a code based on the project' do
          expect(card.code).to eq("#{card.project.code}-0001")
        end
      end
    end

    describe 'before_destroy' do
      describe '#delete_images' do
        let!(:card) { create(:card) }

        it 'should call delete images service object' do
          expect_any_instance_of(S3::DeleteImagesFromHtmlService).to receive(:call)

          card.destroy
        end
      end
    end
  end
end
