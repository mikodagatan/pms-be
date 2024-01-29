require 'rails_helper'

RSpec.describe MentionCardAssigneeDecorator do
  let(:user) { create(:user) }
  let(:project) { create(:project, users: [user]) }
  let(:column) { create(:column, project:) }
  let(:card) { create(:card, column:, assignees: [user]) }
  let(:mention) { create(:mention, resource: card.card_assignees.first) }
  let(:decorator) { MentionCardAssigneeDecorator.new(mention) }

  describe '#assignment' do
    it 'returns the assigned resource' do
      expect(decorator.assignment).to eq(card.card_assignees.first)
    end
  end

  describe '#card' do
    it 'returns the associated card' do
      expect(decorator.card).to eq(card)
    end
  end

  describe '#content' do
    it 'returns the description of the card' do
      expect(decorator.content).to eq(card.description)
    end
  end

  describe '#project' do
    it 'returns the project of the card' do
      expect(decorator.project).to eq(project)
    end
  end

  describe '#code' do
    it 'returns the code of the card' do
      expect(decorator.code).to eq(card.code)
    end
  end

  describe '#url' do
    it 'returns the URL of the card' do
      expected_url = "#{ENV['FRONT_END_URL']}/app/projects/#{project.id}?card=#{card.code}"
      expect(decorator.url).to eq(expected_url)
    end
  end
end
