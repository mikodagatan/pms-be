class UserMentionSerializer < Blueprinter::Base
  identifier :id

  field :value do |user|
    user.full_name
  end
end
