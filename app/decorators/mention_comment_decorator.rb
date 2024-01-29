class MentionCommentDecorator
  attr_reader :mention, :comment

  def initialize(mention)
    @mention = mention
    @comment = mention.resource
  end

  def content
    comment.content
  end

  def project
    comment.resource.column.project
  end

  def card
    comment.resource
  end

  def code
    card.code
  end

  def mentioned_in
    "a comment within #{code}"
  end

  def url
    "#{ENV['FRONT_END_URL']}/app/projects/#{project.id}?card=#{card.code}/"
  end
end
