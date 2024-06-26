class CardHistory < ApplicationRecord
  belongs_to :card
  belongs_to :user

  enum action: %i[create_action update_action destroy_action move_action]

  enum action_status: %i[normal improved worsened]
end
