class Card < ApplicationRecord
  belongs_to :column
  acts_as_list scope: :column

  has_one :project, through: :column

  before_validation :assign_code

  private

  def assign_code
    previous_number = project.cards&.last&.code&.split('-')&.last&.to_i
    new_number = previous_number ? previous_number + 1 : 1
    self.code = "#{project.code}-#{new_number}"
  end
end
