class CardAssignee < ApplicationRecord
  belongs_to :card
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id'

  has_one :mention, as: :resource, dependent: :destroy
end
