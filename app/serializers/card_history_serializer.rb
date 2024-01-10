class CardHistorySerializer < Blueprinter::Base
  identifier :id

  field :google_photo_url do |history|
    history.user.google_photo_url
  end
  field :full_name do |history|
    history.user.full_name
  end

  fields :attr, :output, :from, :to, :action_status, :created_at
end
