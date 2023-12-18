class Card < ApplicationRecord
  belongs_to :column
  acts_as_list scope: :column
  has_one :project, through: :column

  belongs_to :requester, class_name: 'User', foreign_key: :requester_id, required: false

  has_many :card_assignees
  has_many :assignees, through: :card_assignees, source: :assignee

  before_create :assign_code

  private

  def assign_code
    previous_number = project.cards.order(code: :asc)&.last&.code&.split('-')&.last&.to_i
    new_number = previous_number ? previous_number + 1 : 1
    self.code = "#{project.code}-#{new_number.to_s.rjust(4, '0')}"
  end
end
