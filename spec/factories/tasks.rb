FactoryBot.define do
  factory :task do
    card { nil }
    name { "MyString" }
    checked { false }
    position { 1 }
    type { "" }
  end
end
