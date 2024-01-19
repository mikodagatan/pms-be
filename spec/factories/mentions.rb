FactoryBot.define do
  factory :mention do
    commenter { create(:user) }
    mentioned { create(:user) }
    resource { nil }
  end

  factory :mention_comment, parent: :mention do
    resource { create(:comment) }
  end

  factory :mention_card, parent: :mention do
    resource { create(:card) }
  end
end
