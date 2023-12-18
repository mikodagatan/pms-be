class User < ApplicationRecord
  has_many :company_users
  has_many :companies, through: :company_users

  has_many :project_users
  has_many :projects, through: :project_users

  validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, uniqueness: true
end
