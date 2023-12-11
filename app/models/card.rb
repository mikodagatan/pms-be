class Card < ApplicationRecord
  belongs_to :column

  has_one :project, through: :column
end
