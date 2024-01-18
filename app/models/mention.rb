class Mention < ApplicationRecord
  belongs_to :commenter, class_name: 'User'
  belongs_to :mentioned, class_name: 'User'
  belongs_to :resource, polymorphic: true

  def email_sent?
    email_sent_at.present?
  end
end
