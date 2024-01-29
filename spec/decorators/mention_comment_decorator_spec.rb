require 'rails_helper'

RSpec.describe MentionCommentDecorator do
  let(:project) { create(:project) }
  let(:column) { create(:column, project:) }
  let(:card) { create(:card, column:) }
  let(:comment) { create(:comment, resource: card) }
  let(:mention) { create(:mention, resource: comment) }
  let(:decorator) { MentionCommentDecorator.new(mention) }

  describe '#content' do
    it 'returns the content of the comment' do
      expect(decorator.content).to eq(comment.content)
    end
  end

  describe '#project' do
    context 'when the comment is associated with a card' do
      it 'returns the project of the card' do
        expect(decorator.project).to eq(project)
      end
    end
  end

  describe '#card' do
    it 'returns the card associated with the comment' do
      expect(decorator.card).to eq(card)
    end
  end

  describe '#code' do
    it 'returns the code of the card associated with the comment' do
      expect(decorator.code).to eq(card.code)
    end
  end

  describe '#mentioned_in' do
    it 'returns the string indicating the comment is within a card' do
      expect(decorator.mentioned_in).to eq("a comment within #{card.code}")
    end
  end

  describe '#url' do
    it 'returns the URL of the card associated with the comment' do
      expected_url = "#{ENV['FRONT_END_URL']}/app/projects/#{project.id}?card=#{card.code}/"
      expect(decorator.url).to eq(expected_url)
    end
  end
end
