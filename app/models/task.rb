class Task < ApplicationRecord
  belongs_to :card
  acts_as_list scope: %i[type card_id]
end
