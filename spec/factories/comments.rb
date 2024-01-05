FactoryBot.define do
  factory :comment do
    content { "MyText" }
    commenter { nil }
    resource { nil }
  end
end
