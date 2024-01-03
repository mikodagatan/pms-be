class Openai::Thread < ApplicationRecord
  belongs_to :project

  validates :thread_id, presence: true
  validates :project_id, uniqueness: true
end
