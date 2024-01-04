class TaskSerializer < Blueprinter::Base
  identifier :id

  fields :name, :position, :checked, :type
end
