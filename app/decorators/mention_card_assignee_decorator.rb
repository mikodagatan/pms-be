class MentionCardAssigneeDecorator
  attr_reader :mention

  def initialize(mention)
    @mention = mention
  end

  def assignment
    mention.resource
  end

  def card
    assignment.card
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

  def url
    "#{ENV['FRONT_END_URL']}/app/projects/#{project.id}?card=#{code}"
  end
end
