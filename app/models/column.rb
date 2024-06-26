class Column < ApplicationRecord
  belongs_to :project
  acts_as_list scope: :project

  has_many :cards, dependent: :destroy
end
