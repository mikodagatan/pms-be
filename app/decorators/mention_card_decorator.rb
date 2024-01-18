class MentionCardDecorator
  attr_reader :mention, :card

  def initialize(mention)
    @mention = mention
    @card = mention.resource
  end

  def content
    card.description
  end

  def project
    card.column.project
  end

  def code
    card.code
  end

  def mentioned_in
    code
  end

  def url
    "#{ENV['FRONT_END_URL']}/app/projects/#{project.id}?card=#{card.code}"
  end
end
