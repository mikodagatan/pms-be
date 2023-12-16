class User < ApplicationRecord
  has_many :company_users
  has_many :companies, through: :company_users

  validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
