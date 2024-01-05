class CommentSerializer < Blueprinter::Base
  identifier :id

  fields :resource_id, :resource_type, :commenter_id
  field :full_name do |comment|
    comment.commenter.full_name
  end
  field :photo_url do |comment|
    comment.commenter.google_photo_url
  end
  fields :content, :created_at, :updated_at
end
