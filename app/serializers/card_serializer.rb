class CardSerializer < Blueprinter::Base
  identifier :id

  fields :name, :code, :description, :position
end
