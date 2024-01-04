class CardSerializer < Blueprinter::Base
  identifier :id

  fields :name, :code, :description, :position, :column_id, :requester_id

  field :assignee_ids do |card|
    card.assignees.pluck(:id)
  end

  association :developer_tasks, blueprint: TaskSerializer do |card|
    card.developer_tasks
  end

  association :user_testing_tasks, blueprint: TaskSerializer do |card|
    card.user_testing_tasks
  end
end
