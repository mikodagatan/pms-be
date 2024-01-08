class CardHistorySerializer < Blueprinter::Base
  identifier :id

  field :google_photo_url do |history|
    history.user.google_photo_url
  end

  field :output
end
