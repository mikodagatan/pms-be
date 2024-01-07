class Comment < ApplicationRecord
  belongs_to :commenter, class_name: 'User'
  belongs_to :resource, polymorphic: true

  validates :content, presence: true

  before_destroy :delete_images

  def delete_images
    S3::DeleteImagesFromHtmlService.new(content).call
  end
end
