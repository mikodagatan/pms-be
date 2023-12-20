class CardSerializer < Blueprinter::Base
  identifier :id

  fields :name, :code, :description, :position, :column_id, :requester_id

  field :assignee_ids do |card|
    card.assignees.pluck(:id)
  end
end
