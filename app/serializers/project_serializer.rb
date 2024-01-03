class ProjectSerializer < Blueprinter::Base
  identifier :id

  fields :name, :code, :scope

  association :columns, blueprint: ColumnSerializer do |project|
    project.columns.order(position: :asc)
  end

  association :users, blueprint: UserSerializer do |project|
    project.users
  end
end
