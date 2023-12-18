class Project < ApplicationRecord
  has_many :columns
  has_many :cards, through: :columns

  has_many :project_users
  has_many :users, through: :project_users

  validates :code, uniqueness: true
end
