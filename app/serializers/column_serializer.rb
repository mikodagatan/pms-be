class ColumnSerializer < Blueprinter::Base
  identifier :id

  fields :name, :position

  association :cards,
              blueprint: CardSerializer,
              default_if: Blueprinter::EMPTY_COLLECTION,
              default: [] do |column|
    column.cards.order(position: :asc)
  end
end
