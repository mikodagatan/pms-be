class User < ApplicationRecord
  has_secure_password

  has_many :company_users
  has_many :companies, through: :company_users

  has_many :project_users
  has_many :projects, through: :project_users

  has_many :card_assignees, foreign_key: 'assignee_id'
  has_many :assigned_cards, through: :card_assignees, source: :card

  has_many :mentioneds, class_name: 'Mention', foreign_key: 'mentioned_id'
  has_many :mentions, class_name: 'Mention', foreign_key: 'commenter_id'

  validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, uniqueness: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def confirmed?
    confirmed_at.present?
  end
end
