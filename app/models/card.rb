class Card < ApplicationRecord
  belongs_to :column
  acts_as_list scope: :column
  has_one :project, through: :column

  belongs_to :requester, class_name: 'User', foreign_key: :requester_id, required: false

  has_many :card_assignees, dependent: :destroy
  has_many :assignees, through: :card_assignees, source: :assignee

  has_many :developer_tasks, -> { order(position: :asc) }, class_name: 'DeveloperTask', dependent: :destroy
  has_many :user_testing_tasks, -> { order(position: :asc) }, class_name: 'UserTestingTask', dependent: :destroy

  has_many :comments, -> { order(created_at: :desc) }, as: :resource, dependent: :destroy

  has_many :histories, -> { order(created_at: :desc) }, class_name: 'CardHistory', dependent: :destroy

  has_many :mentions, as: :resource, dependent: :destroy

  before_create :assign_code
  before_destroy :delete_images

  private

  def assign_code
    previous_number = project.cards.order(code: :asc)&.last&.code&.split('-')&.last&.to_i
    new_number = previous_number ? previous_number + 1 : 1
    self.code = "#{project.code}-#{new_number.to_s.rjust(4, '0')}"
  end

  def delete_images
    S3::DeleteImagesFromHtmlService.new(description).call
  end
end
