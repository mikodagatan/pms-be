require 'rails_helper'

RSpec.describe MentionDecorator do
  let(:project) { create(:project) }
  let(:column) { create(:column, project:) }
  let(:assignee) { create(:user) }
  let(:card) { create(:card, column:, assignees: [assignee]) }
  let(:comment) { create(:comment, resource: card) }
  let(:mention_card) { create(:mention, resource: card) }
  let(:mention_comment) { create(:mention, resource: comment) }
  let(:mention_assignee) { create(:mention, resource: card.card_assignees.first) }

  describe '#call' do
    context 'when the mention resource type is a card' do
      it 'instantiates MentionCardDecorator' do
        decorator = MentionDecorator.new(mention_card).call
        expect(decorator).to be_an_instance_of(MentionCardDecorator)
      end
    end

    context 'when the mention resource type is a comment' do
      it 'instantiates MentionCommentDecorator' do
        decorator = MentionDecorator.new(mention_comment).call
        expect(decorator).to be_an_instance_of(MentionCommentDecorator)
      end
    end

    context 'when the mention resource type is an assignee' do
      it 'instantiates MentionCardAssigneeDecorator' do
        decorator = MentionDecorator.new(mention_assignee).call
        expect(decorator).to be_an_instance_of(MentionCardAssigneeDecorator)
      end
    end

    context 'when the mention resource type is unknown' do
      it 'raises an error' do
        mention_unknown = double('Mention', resource_type: 'Unknown')
        expect do
          MentionDecorator.new(mention_unknown).call
        end.to raise_error(NameError)
      end
    end
  end
end
