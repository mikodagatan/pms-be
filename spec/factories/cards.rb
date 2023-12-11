FactoryBot.define do
  factory :card do
    column { nil }
    name { "MyString" }
    code { "MyString" }
    description { "MyText" }
    priority { 1 }
    position { 1 }
  end
end
