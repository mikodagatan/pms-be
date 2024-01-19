require 'rails_helper'

RSpec.describe Mention, type: :model do
  describe 'associations' do
    it { should belong_to(:commenter).class_name('User') }
    it { should belong_to(:mentioned).class_name('User') }
    it { should belong_to(:resource) }
  end

  describe 'methods' do
    describe '#email_sent?' do
      let!(:mention) { create(:mention_card, email_sent_at: DateTime.current) }

      it 'should return true' do
        expect(mention.email_sent?).to be_truthy
      end
    end
  end
end
