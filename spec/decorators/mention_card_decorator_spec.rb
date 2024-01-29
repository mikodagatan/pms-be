require 'rails_helper'

RSpec.describe MentionCardDecorator do
  let(:project) { create(:project) }
  let(:column) { create(:column, project:) }
  let(:card) { create(:card, column:) }
  let(:mention) { create(:mention, resource: card) }
  let(:decorator) { MentionCardDecorator.new(mention) }

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

  describe '#mentioned_in' do
    it 'returns the code of the card' do
      expect(decorator.mentioned_in).to eq(card.code)
    end
  end

  describe '#url' do
    it 'returns the URL of the card' do
      expected_url = "#{ENV['FRONT_END_URL']}/app/projects/#{project.id}?card=#{card.code}"
      expect(decorator.url).to eq(expected_url)
    end
  end
end
