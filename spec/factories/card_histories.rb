FactoryBot.define do
  factory :card_history do
    card { nil }
    user { nil }
    attr { "MyString" }
    from { "MyText" }
    to { "MyText" }
  end
end
