class ColumnSerializer < Blueprinter::Base
  identifier :id

  fields :name, :position

  association :cards, blueprint: CardSerializer do |column|
    column.cards.order(position: :asc)
  end
end
