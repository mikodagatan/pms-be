class Project < ApplicationRecord
  has_many :columns
  has_many :cards, through: :columns
end
