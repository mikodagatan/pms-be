class Project < ApplicationRecord
  has_many :columns
  has_many :cards, through: :columns

  validates :code, uniqueness: true
end
