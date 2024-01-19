require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { should belong_to(:commenter).class_name('User') }
    it { should belong_to(:resource) }

    it { should have_many(:mentions) }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
  end

  describe 'callbacks' do
    describe 'before_destroy' do
      describe '#delete_images' do
        let!(:comment) { create(:comment) }

        it 'should call delete images service object' do
          expect_any_instance_of(S3::DeleteImagesFromHtmlService).to receive(:call)

          comment.destroy
        end
      end
    end
  end
end
