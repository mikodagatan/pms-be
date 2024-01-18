class MentionDecorator
  attr_reader :mention

  def initialize(mention)
    @mention = mention
  end

  def call
    "Mention#{mention.resource_type}Decorator".constantize.new(mention)
  end
end
