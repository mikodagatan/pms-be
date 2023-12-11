class ProjectSerializer < Blueprinter::Base
  identifier :id

  fields :name, :code

  association :columns, blueprint: ColumnSerializer do |project|
    project.columns.order(position: :asc)
  end
end
