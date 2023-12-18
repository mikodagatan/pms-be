class ProjectSerializer < Blueprinter::Base
  identifier :id

  fields :name, :code

  association :columns, blueprint: ColumnSerializer do |project|
    project.columns.order(position: :asc)
  end

  association :user_mentions, blueprint: UserMentionSerializer do |project|
    project.users
  end
end
